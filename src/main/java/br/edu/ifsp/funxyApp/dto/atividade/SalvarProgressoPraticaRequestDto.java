package br.edu.ifsp.funxyApp.dto.atividade;

import com.fasterxml.jackson.databind.node.ArrayNode;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import java.util.UUID;
public record SalvarProgressoPraticaRequestDto(
        @NotNull ArrayNode listaFuncoes,
        @NotNull ArrayNode listaFuncoesValidas,
        @NotNull ArrayNode listaDominios,
        @NotNull @PositiveOrZero Integer movimentos,
        @NotNull boolean concluida,
        @NotNull UUID tentativaUuid
) {}