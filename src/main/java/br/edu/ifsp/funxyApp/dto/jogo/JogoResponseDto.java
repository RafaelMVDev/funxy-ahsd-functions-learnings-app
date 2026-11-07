package br.edu.ifsp.funxyApp.dto.jogo;

import java.util.List;

public record JogoResponseDto(
        List<Trilha> trilhas,
        List<Conquista> conquistas,
        List<Item> itens
) {

    public record Trilha(
            Long trilhaId,
            List<Atividade> atividades
    ) {}

    public record Atividade(
            Long atividadeId,
            Integer numeroAtividade,
            String titulo,
            String descricao,
            String tipo,
            Long xpBase,
            Integer moedaBase,
            ConteudoAtividade conteudo
    ) {}

    public sealed interface ConteudoAtividade permits Leitura, Pratica {}

    public record ColisaoMalha(
            String tipo,
            double x,
            double y,
            double largura,
            double altura
    ) {}
    public record Leitura(
            String textos,
            String imagens
    ) implements ConteudoAtividade {}

    public record Pratica(
            Integer mediaMovimentos,
            String colisoesMalha
    ) implements ConteudoAtividade {}

    public record Conquista(
            Long conquistaId,
            String nome,
            String descricao,
            String tipo,
            Long valorCondicao
    ) {}

    public record Item(
            Long itemId,
            String descricao,
            String metadados,
            String tipo,
            String estilo,
            Long valor,
            Long xpNecessario
    ) {}
}