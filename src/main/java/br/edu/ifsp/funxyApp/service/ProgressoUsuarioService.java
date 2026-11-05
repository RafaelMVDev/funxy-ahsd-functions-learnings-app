package br.edu.ifsp.funxyApp.service;

import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto;
import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto.*;
import br.edu.ifsp.funxyApp.model.Progresso;
import br.edu.ifsp.funxyApp.model.ProgressoLeitura;
import br.edu.ifsp.funxyApp.model.ProgressoPratica;
import br.edu.ifsp.funxyApp.repository.ProgressoLeituraRepository;
import br.edu.ifsp.funxyApp.repository.ProgressoPraticaRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

@Service
public class ProgressoUsuarioService {

    private final ProgressoLeituraRepository leituras;
    private final ProgressoPraticaRepository praticas;

    public ProgressoUsuarioService(
            ProgressoLeituraRepository leituras,
            ProgressoPraticaRepository praticas
    ) {
        this.leituras = leituras;
        this.praticas = praticas;
    }

    @Transactional(readOnly = true)
    public List<TrilhaProgressoDto> buscarTrilhas(Long usuarioId) {
        // Primeira chave: trilhaId. Segunda chave: atividadeId.
        Map<Long, Map<Long, List<Tentativa>>> porTrilha = new TreeMap<>();

        for (ProgressoLeitura p : leituras.findByUsuario_Id(usuarioId)) {
            adicionarTentativa(porTrilha, p, new Leitura(p.getPaginaAtual()));
        }

        for (ProgressoPratica p : praticas.findByUsuario_Id(usuarioId)) {
            adicionarTentativa(porTrilha, p,
                    new Pratica(p.getPosicaoAtual(), p.getMovimentos()));
        }

        Comparator<Tentativa> maisRecentePrimeiro = Comparator
                .comparing(Tentativa::iniciadaEm)
                .thenComparing(Tentativa::progressoId)
                .reversed();

        List<TrilhaProgressoDto> resultado = new ArrayList<>();

        porTrilha.forEach((trilhaId, porAtividade) -> {
            List<AtividadeProgresso> atividades = new ArrayList<>();

            porAtividade.forEach((atividadeId, tentativas) -> {
                tentativas.sort(maisRecentePrimeiro);
                atividades.add(new TrilhaProgressoDto.AtividadeProgresso(atividadeId, tentativas));
            });

            resultado.add(new TrilhaProgressoDto(trilhaId, atividades));
        });

        return resultado;
    }

    private void adicionarTentativa(
            Map<Long, Map<Long, List<Tentativa>>> porTrilha,
            Progresso progresso,
            TrilhaProgressoDto.ProgressoEspecifico progressoEspecifico
    ) {
        Long atividadeId = progresso.getAtividade().getId();
        Long trilhaId = progresso.getAtividade().getIdTrilha();

        Tentativa tentativa = new Tentativa(
                progresso.getId(),
                progresso.getDatetimeConclusao() == null ? "em_andamento" : "concluido",
                progresso.getDatetimeInicio(),
                progresso.getDatetimeConclusao(),
                progressoEspecifico
        );

        porTrilha
                .computeIfAbsent(trilhaId, id -> new TreeMap<>())
                .computeIfAbsent(atividadeId, id -> new ArrayList<>())
                .add(tentativa);
    }
}