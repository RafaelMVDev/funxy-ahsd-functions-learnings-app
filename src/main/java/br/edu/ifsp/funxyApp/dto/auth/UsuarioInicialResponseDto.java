package br.edu.ifsp.funxyApp.dto.auth;

import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto;

import java.time.LocalDateTime;
import java.util.List;

//TODO: ATUALIZAR DTO PARA RETORNAR DADOS INICIAS DO JOGO ( TRILHA DE ATIVIDADES E CONQUISTAS BASE)
//TODO: ADICIONAR DTO PARA RETORNAR DADOS BASE DO JOGO E ENDPOINT PARA ISSO!
public record UsuarioInicialResponseDto(
        Perfil usuario,
        Preferencias configuracao,
        List<ItemInventario> inventario,
        List<ConquistaDesbloqueada> conquistas,
        List<TrilhaProgressoDto> trilhas
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
            LocalDateTime desbloqueadaEm
    ) {}

    public record TrilhaRealizada(
            Long trilhaId,
            List<AtividadeRealizada> atividadesRealizadas
    ) {}

    public record AtividadeRealizada(
            Long progressoId,
            Long atividadeId,
            Integer numeroAtividade,
            String titulo,
            String tipo,
            LocalDateTime iniciadaEm,
            LocalDateTime concluidaEm
    ) {}
}