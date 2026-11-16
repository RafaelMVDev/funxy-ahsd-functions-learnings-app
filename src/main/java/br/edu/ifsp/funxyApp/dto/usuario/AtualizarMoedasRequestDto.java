package br.edu.ifsp.funxyApp.dto.usuario;


import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

public record AtualizarMoedasRequestDto(
        @NotNull(message = "Informe o total de moedas.")
        @PositiveOrZero(message = "O total de moedas não pode ser negativo.")
        Long moedas
) {}