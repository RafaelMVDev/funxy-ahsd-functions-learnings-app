package br.edu.ifsp.funxyApp.dto.trilha;

import java.time.LocalDateTime;
import java.util.List;

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
            String status,
            LocalDateTime iniciadaEm,
            LocalDateTime concluidaEm,
            ProgressoEspecifico progressoEspecifico
    ) {}

    public sealed interface ProgressoEspecifico permits Leitura, Pratica {}

    public record Leitura(Integer paginaAtual) implements ProgressoEspecifico {}

    public record Pratica(
            String posicaoAtual,
            Integer movimentos
    ) implements ProgressoEspecifico {}
}