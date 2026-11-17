package br.edu.ifsp.funxyApp.dto.atividade;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

public record SalvarProgressoLeituraRequestDto(
        @NotNull
        @PositiveOrZero
        Integer paginaAtual,

        @NotNull
        Boolean status
) {}