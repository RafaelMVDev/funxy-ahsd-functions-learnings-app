package br.edu.ifsp.funxyApp.dto.auth;

import java.time.LocalDateTime;
import java.util.List;

public record UsuarioInicialResponseDto(
        Perfil usuario,
        Preferencias configuracao,
        List<ItemInventario> inventario,
        List<ConquistaDesbloqueada> conquistas
) {

    public record Perfil(
            Long id,
            String nome,
            String email,
            Integer sequencia,
            Long moedas,
            Long xp
    ) {}

    public record Preferencias(
            String tema,
            String idioma,
            Boolean notificacao
    ) {}

    public record ItemInventario(
            Long inventarioId,
            Long itemId,
            String descricao,
            String metadados,
            String tipo,
            String estilo,
            Boolean equipado
    ) {}

    public record ConquistaDesbloqueada(
            Long conquistaId,
            String nome,
            String descricao,
            String tipo,
            Long valorCondicao,
            LocalDateTime desbloqueadaEm
    ) {}
}