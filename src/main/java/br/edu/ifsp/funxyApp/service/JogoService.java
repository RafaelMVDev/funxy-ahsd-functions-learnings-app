package br.edu.ifsp.funxyApp.service;

import br.edu.ifsp.funxyApp.dto.jogo.JogoResponseDto;
import br.edu.ifsp.funxyApp.dto.jogo.RankingJogadorDto;
import br.edu.ifsp.funxyApp.model.*;
import br.edu.ifsp.funxyApp.repository.AtividadesRepository;
import br.edu.ifsp.funxyApp.repository.ConquistasRepository;
import br.edu.ifsp.funxyApp.repository.ItensRepository;
import br.edu.ifsp.funxyApp.repository.UsuarioRepository;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional(readOnly = true)
public class JogoService {

    private final AtividadesRepository atividades;
    private final ConquistasRepository conquistas;
    private final UsuarioRepository usuarios;
    private final ItensRepository itens;
    private final ObjectMapper objectMapper;

    public JogoService(
            AtividadesRepository atividades,
            ConquistasRepository conquistas,
            UsuarioRepository usuarios,
            ItensRepository itens,
            ObjectMapper objectMapper
    ) {
        this.atividades = atividades;
        this.conquistas = conquistas;
        this.itens = itens;
        this.objectMapper = objectMapper;
        this.usuarios = usuarios;
    }

    public JogoResponseDto carregarTudo() {
        return new JogoResponseDto(
                buscarTrilhas(),
                buscarConquistas(),
                buscarItens()
        );
    }

    public List<JogoResponseDto.Trilha> buscarTrilhas() {
        Map<Long, List<JogoResponseDto.Atividade>> atividadesPorTrilha =
                new LinkedHashMap<>();

        for (Atividades atividade :
                atividades.findAllByOrderByTrilha_IdAscNumeroAtividadeAsc()) {

            Long trilhaId = atividade.getIdTrilha();

            atividadesPorTrilha
                    .computeIfAbsent(trilhaId, id -> new ArrayList<>())
                    .add(montarAtividade(atividade));
        }

        return atividadesPorTrilha.entrySet()
                .stream()
                .map(grupo -> new JogoResponseDto.Trilha(
                        grupo.getKey(),
                        grupo.getValue()
                ))
                .toList();
    }

    public List<JogoResponseDto.Conquista> buscarConquistas() {
        return conquistas.findAll(Sort.by("id"))
                .stream()
                .map(conquista -> new JogoResponseDto.Conquista(
                        conquista.getId(),
                        conquista.getNome(),
                        conquista.getDescricao(),
                        nomeEnum(conquista.getTipo()),
                        conquista.getValorCondicao()
                ))
                .toList();
    }

    public List<JogoResponseDto.Item> buscarItens() {
        return itens.findAll(Sort.by("id"))
                .stream()
                .map(this::montarItem)
                .toList();
    }

    private ArrayNode converterColisoes(String json) {
        try {
            JsonNode dados = objectMapper.readTree(json);

            if (!(dados instanceof ArrayNode array)) {
                throw new IllegalStateException(
                        "As colisões da atividade devem ser um array JSON."
                );
            }

            return array;
        } catch (JsonProcessingException e) {
            throw new IllegalStateException(
                    "As colisões da atividade contêm um JSON inválido.", e
            );
        }
    }

    private JogoResponseDto.Atividade montarAtividade(Atividades atividade) {
        JogoResponseDto.ConteudoAtividade conteudo;

        if (atividade instanceof AtividadeLeitura leitura) {
            conteudo = new JogoResponseDto.Leitura(
                    leitura.getTexto(),
                    leitura.getImagens()
            );
        } else if (atividade instanceof AtividadePratica pratica) {
            conteudo = new JogoResponseDto.Pratica(
                    pratica.getMediaMovimentos(),
                    converterColisoes(pratica.getColisoesMalha())
            );
        } else {
            throw new IllegalStateException(
                    "Atividade sem especialização de leitura ou prática: "
                            + atividade.getId()
            );
        }

        return new JogoResponseDto.Atividade(
                atividade.getId(),
                atividade.getNumeroAtividade(),
                atividade.getTitulo(),
                atividade.getDescricao(),
                nomeEnum(atividade.getTipo()),
                atividade.getXpBase(),
                atividade.getMoedaBase(),
                conteudo
        );
    }

    private JogoResponseDto.Item montarItem(Itens item) {
        Long valor = null;
        Long xpNecessario = null;

        if (item instanceof ItemLoja loja) {
            valor = loja.getValor();
        } else if (item instanceof ItemPasseBatalha passe) {
            xpNecessario = passe.getXpNecessario();
        }

        return new JogoResponseDto.Item(
                item.getId(),
                item.getDescricao(),
                item.getMetadados(),
                nomeEnum(item.getTipo()),
                nomeEnum(item.getEstilo()),
                valor,
                xpNecessario
        );
    }
    @Transactional(readOnly = true)
    public List<RankingJogadorDto> buscarRanking() {
        List<Usuario> jogadores = usuarios.findTop15ByOrderByXpDescIdAsc();
        List<RankingJogadorDto> ranking = new ArrayList<>();

        for (int i = 0; i < jogadores.size(); i++) {
            Usuario usuario = jogadores.get(i);

            ranking.add(new RankingJogadorDto(
                    i + 1,
                    usuario.getId(),
                    usuario.getNome(),
                    usuario.getXp()
            ));
        }

        return ranking;
    }
    private static String nomeEnum(Enum<?> valor) {
        return valor == null ? null : valor.name();
    }
}
