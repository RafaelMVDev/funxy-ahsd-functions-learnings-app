package br.edu.ifsp.funxyApp.service;

import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto;
import br.edu.ifsp.funxyApp.model.Atividades;
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
        Map<Long, List<TrilhaProgressoDto.Tentativa>> porTrilha =
                new TreeMap<>(Comparator.nullsLast(Long::compareTo));

        for (ProgressoLeitura leitura : leituras.findByUsuario_Id(usuarioId)) {
            adicionarTentativa(
                    porTrilha,
                    leitura,
                    "leitura",
                    new TrilhaProgressoDto.Leitura(leitura.getPaginaAtual())
            );
        }

        for (ProgressoPratica pratica : praticas.findByUsuario_Id(usuarioId)) {
            adicionarTentativa(
                    porTrilha,
                    pratica,
                    "pratica",
                    new TrilhaProgressoDto.Pratica(
                            pratica.getPosicaoAtual(),
                            pratica.getMovimentos()
                    )
            );
        }

        List<TrilhaProgressoDto> resultado = new ArrayList<>();

        porTrilha.forEach((trilhaId, tentativas) -> {
            tentativas.sort(
                    Comparator.comparing(TrilhaProgressoDto.Tentativa::numeroAtividade)
                            .thenComparing(
                                    TrilhaProgressoDto.Tentativa::iniciadaEm,
                                    Comparator.reverseOrder()
                            )
                            .thenComparing(
                                    TrilhaProgressoDto.Tentativa::progressoId,
                                    Comparator.reverseOrder()
                            )
            );

            resultado.add(new TrilhaProgressoDto(trilhaId, List.copyOf(tentativas)));
        });

        return resultado;
    }

    private void adicionarTentativa(
            Map<Long, List<TrilhaProgressoDto.Tentativa>> porTrilha,
            Progresso progresso,
            String tipo,
            TrilhaProgressoDto.ProgressoEspecifico progressoEspecifico
    ) {
        Atividades atividade = progresso.getAtividade();

        String status = progresso.getDatetimeConclusao() == null
                ? "em_andamento"
                : "concluido";

        TrilhaProgressoDto.Tentativa tentativa = new TrilhaProgressoDto.Tentativa(
                progresso.getId(),
                atividade.getId(),
                atividade.getNumeroAtividade(),
                atividade.getTitulo(),
                tipo,
                status,
                progresso.getDatetimeInicio(),
                progresso.getDatetimeConclusao(),
                progressoEspecifico
        );

        porTrilha.computeIfAbsent(
                atividade.getIdTrilha(), id -> new ArrayList<>()
        ).add(tentativa);
    }
}