package br.edu.ifsp.funxyApp.dto.jogo;

public record RankingJogadorDto(
        Integer posicao,
        Long usuarioId,
        String nome,
        Long xp
) {}

