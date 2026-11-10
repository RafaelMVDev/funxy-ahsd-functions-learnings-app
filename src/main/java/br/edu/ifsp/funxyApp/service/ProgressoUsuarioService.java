package br.edu.ifsp.funxyApp.service;

import br.edu.ifsp.funxyApp.dto.atividade.SalvarProgressoPraticaRequestDto;
import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto;
import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto.AtividadeProgresso;
import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto.Leitura;
import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto.Pratica;
import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto.ProgressoEspecifico;
import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto.Tentativa;
import br.edu.ifsp.funxyApp.model.AtividadePratica;
import br.edu.ifsp.funxyApp.model.Atividades;
import br.edu.ifsp.funxyApp.model.Progresso;
import br.edu.ifsp.funxyApp.model.ProgressoLeitura;
import br.edu.ifsp.funxyApp.model.ProgressoPratica;
import br.edu.ifsp.funxyApp.model.Usuario;
import br.edu.ifsp.funxyApp.repository.AtividadesRepository;
import br.edu.ifsp.funxyApp.repository.ProgressoLeituraRepository;
import br.edu.ifsp.funxyApp.repository.ProgressoPraticaRepository;
import br.edu.ifsp.funxyApp.repository.UsuarioRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.TreeMap;

@Service
public class ProgressoUsuarioService {

    private final ProgressoLeituraRepository leituras;
    private final ProgressoPraticaRepository praticas;
    private final UsuarioRepository usuarios;
    private final AtividadesRepository atividades;
    private final ObjectMapper objectMapper;

    public ProgressoUsuarioService(
            ProgressoLeituraRepository leituras,
            ProgressoPraticaRepository praticas,
            UsuarioRepository usuarios,
            AtividadesRepository atividades,
            ObjectMapper objectMapper
    ) {
        this.leituras = leituras;
        this.praticas = praticas;
        this.usuarios = usuarios;
        this.atividades = atividades;
        this.objectMapper = objectMapper;
    }

    @Transactional(readOnly = true)
    public List<TrilhaProgressoDto> buscarTrilhas(Long usuarioId) {
        Map<Long, Map<Long, List<Tentativa>>> porTrilha = new TreeMap<>();

        for (ProgressoLeitura progresso : leituras.findByUsuario_Id(usuarioId)) {
            Tentativa tentativa = montarTentativa(
                    progresso,
                    new Leitura(progresso.getPaginaAtual())
            );

            adicionarTentativa(porTrilha, progresso.getAtividade(), tentativa);
        }

        for (ProgressoPratica progresso : praticas.findByUsuario_Id(usuarioId)) {
            Tentativa tentativa = montarTentativaPratica(progresso);
            adicionarTentativa(porTrilha, progresso.getAtividade(), tentativa);
        }

        Comparator<Tentativa> porStatusEConclusao = Comparator
                .comparing(Tentativa::atividadeConcluida)
                .thenComparing(
                        Tentativa::concluidaEm,
                        Comparator.nullsLast(Comparator.reverseOrder())
                )
                .thenComparing(Tentativa::progressoId, Comparator.reverseOrder());

        List<TrilhaProgressoDto> resultado = new ArrayList<>();

        porTrilha.forEach((trilhaId, porAtividade) -> {
            List<AtividadeProgresso> fases = new ArrayList<>();

            porAtividade.forEach((atividadeId, tentativas) -> {
                tentativas.sort(porStatusEConclusao);
                fases.add(new AtividadeProgresso(atividadeId, tentativas));
            });

            resultado.add(new TrilhaProgressoDto(trilhaId, fases));
        });

        return resultado;
    }

    @Transactional
    public Tentativa salvarPratica(
            Long usuarioId,
            Long atividadeId,
            SalvarProgressoPraticaRequestDto request
    ) {
        Usuario usuario = usuarios.buscarParaSalvarProgresso(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuário não encontrado."
                ));

        Optional<ProgressoPratica> existente =
                praticas.findByUsuario_IdAndTentativaUuid(
                        usuarioId, request.tentativaUuid()
                );

        ProgressoPratica progresso;

        if (existente.isPresent()) {
            progresso = existente.get();

            if (!atividadeId.equals(progresso.getAtividade().getId())) {
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT, "Essa tentativa pertence a outra atividade."
                );
            }

            if (progresso.getDatetimeConclusao() != null) {
                // O banco já salvou a conclusão. Devolve o mesmo progressoId.
                return montarTentativaPratica(progresso);
            }
        } else {
            AtividadePratica pratica = buscarAtividadePratica(atividadeId);
            validarSalvamentoPratica(usuarioId, pratica);

            // A validação da trilha procura OUTRA atividade aberta.
            // Aqui verificamos se ESTA atividade já tem uma jogada em andamento.
            if (praticas.findByUsuario_IdAndAtividade_IdAndDatetimeConclusaoIsNull(
                    usuarioId, atividadeId
            ).isPresent()) {
                throw new ResponseStatusException(
                        HttpStatus.CONFLICT,
                        "Esta prática já tem uma tentativa aberta. Retome essa tentativa."
                );
            }

            progresso = new ProgressoPratica(usuario, pratica, request.tentativaUuid());
        }

        aplicarEstado(progresso, request);

        if (request.concluida()) {
            progresso.concluir();
        }

        return montarTentativaPratica(praticas.save(progresso));
    }
    private AtividadePratica buscarAtividadePratica(Long atividadeId) {
        Atividades atividade = atividades.findById(atividadeId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Atividade não encontrada."
                ));

        if (!(atividade instanceof AtividadePratica pratica)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Essa atividade não é prática."
            );
        }

        return pratica;
    }

    private void validarSalvamentoPratica(Long usuarioId, AtividadePratica pratica) {
        Long trilhaId = pratica.getIdTrilha();
        Integer numeroAtual = pratica.getNumeroAtividade();

        if (praticas.existeOutraPraticaAberta(usuarioId, trilhaId, pratica.getId())) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Conclua a prática em andamento antes de salvar outra nesta trilha."
            );
        }

        Optional<Integer> anterior =
                atividades.buscarNumeroPraticaAnterior(trilhaId, numeroAtual);

        if (anterior.isEmpty()) {
            return; // É a primeira prática da trilha.
        }

        int numeroAnterior = anterior.get();

        if (!praticas.concluiuPratica(usuarioId, trilhaId, numeroAnterior)) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Conclua a prática " + numeroAnterior
                            + " antes de salvar a prática " + numeroAtual + "."
            );
        }
    }

    private void aplicarEstado(
            ProgressoPratica progresso,
            SalvarProgressoPraticaRequestDto request
    ) {
        progresso.atualizarEstado(
                request.listaFuncoes().toString(),
                request.listaFuncoesValidas().toString(),
                request.listaDominios().toString(),
                request.movimentos()
        );
    }

    private Tentativa montarTentativaPratica(ProgressoPratica progresso) {
        Pratica dadosPratica = new Pratica(
                lerLista(progresso.getListaFuncoes()),
                lerLista(progresso.getListaFuncoesValidas()),
                lerLista(progresso.getListaDominios()),
                progresso.getMovimentos()
        );

        return montarTentativa(progresso, dadosPratica);
    }

    private ArrayNode lerLista(String json) {
        try {
            return objectMapper.readValue(json, ArrayNode.class);
        } catch (JsonProcessingException e) {
            throw new IllegalStateException(
                    "O progresso salvo contém uma lista JSON inválida.", e
            );
        }
    }

    private Tentativa montarTentativa(
            Progresso progresso,
            ProgressoEspecifico progressoEspecifico
    ) {
        LocalDateTime concluidaEm = progresso.getDatetimeConclusao();

        return new Tentativa(
                progresso.getId(),
                concluidaEm != null,
                concluidaEm,
                progressoEspecifico
        );
    }

    private void adicionarTentativa(
            Map<Long, Map<Long, List<Tentativa>>> porTrilha,
            Atividades atividade,
            Tentativa tentativa
    ) {
        porTrilha
                .computeIfAbsent(atividade.getIdTrilha(), id -> new TreeMap<>())
                .computeIfAbsent(atividade.getId(), id -> new ArrayList<>())
                .add(tentativa);
    }
}