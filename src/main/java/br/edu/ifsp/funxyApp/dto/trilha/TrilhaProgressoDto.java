package br.edu.ifsp.funxyApp.dto.trilha;

import com.fasterxml.jackson.databind.node.ArrayNode;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public record TrilhaProgressoDto(
        Long trilhaId,
        List<AtividadeProgresso> atividades
) {
    public record AtividadeProgresso(
            Long atividadeId,
            List<Tentativa> tentativas
    ) {}

    public record Tentativa(
            Long progressoId,
            Boolean concluida,
            LocalDateTime concluidaEm,

            ProgressoEspecifico progressoEspecifico
    ) {}

    public sealed interface ProgressoEspecifico permits Leitura, Pratica {}

    public record Leitura(
            Integer paginaAtual
    ) implements ProgressoEspecifico {}

    public record Pratica(
            ArrayNode listaFuncoes,
            ArrayNode listaFuncoesValidas,
            ArrayNode listaDominios,
            Integer movimentos,
            UUID tentativaUuid
    ) implements ProgressoEspecifico {}
}