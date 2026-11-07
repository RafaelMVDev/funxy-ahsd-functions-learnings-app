package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.PrimaryKeyJoinColumn;
import jakarta.persistence.Table;

@Entity
@Table(name = "Progresso_Pratica")
@PrimaryKeyJoinColumn(name = "id_progresso")
public class ProgressoPratica extends Progresso {

    @Column(name = "lista_funcoes", nullable = false)
    private String listaFuncoes = "[]";

    @Column(name = "lista_funcoes_validas", nullable = false)
    private String listaFuncoesValidas = "[]";

    @Column(name = "lista_dominios", nullable = false)
    private String listaDominios = "[]";

    @Column(name = "movimentos", nullable = false)
    private Integer movimentos = 0;

    protected ProgressoPratica() {}

    public ProgressoPratica(Usuario usuario, AtividadePratica atividade) {
        super(usuario, atividade);
    }

    public String getListaFuncoes() {
        return listaFuncoes;
    }

    public String getListaFuncoesValidas() {
        return listaFuncoesValidas;
    }

    public String getListaDominios() {
        return listaDominios;
    }

    public Integer getMovimentos() {
        return movimentos;
    }

    public void atualizarEstado(
            String listaFuncoes,
            String listaFuncoesValidas,
            String listaDominios,
            int movimentos
    ) {
        this.listaFuncoes = listaFuncoes;
        this.listaFuncoesValidas = listaFuncoesValidas;
        this.listaDominios = listaDominios;
        this.movimentos = movimentos;
    }
}