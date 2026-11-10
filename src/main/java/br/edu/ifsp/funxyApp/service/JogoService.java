package br.edu.ifsp.funxyApp.service;

import br.edu.ifsp.funxyApp.dto.jogo.JogoResponseDto;
import br.edu.ifsp.funxyApp.model.AtividadeLeitura;
import br.edu.ifsp.funxyApp.model.AtividadePratica;
import br.edu.ifsp.funxyApp.model.Atividades;
import br.edu.ifsp.funxyApp.model.ItemLoja;
import br.edu.ifsp.funxyApp.model.ItemPasseBatalha;
import br.edu.ifsp.funxyApp.model.Itens;
import br.edu.ifsp.funxyApp.repository.AtividadesRepository;
import br.edu.ifsp.funxyApp.repository.ConquistasRepository;
import br.edu.ifsp.funxyApp.repository.ItensRepository;
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
    private final ItensRepository itens;

    public JogoService(
            AtividadesRepository atividades,
            ConquistasRepository conquistas,
            ItensRepository itens
    ) {
        this.atividades = atividades;
        this.conquistas = conquistas;
        this.itens = itens;
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
                    pratica.getColisoesMalha()
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

    private static String nomeEnum(Enum<?> valor) {
        return valor == null ? null : valor.name();
    }
}