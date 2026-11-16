package br.edu.ifsp.funxyApp.dto.usuario;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

public record AtualizarXpRequestDto(
        @NotNull(message = "Informe o XP total.")
        @PositiveOrZero(message = "O XP não pode ser negativo.")
        Long xp
) {}