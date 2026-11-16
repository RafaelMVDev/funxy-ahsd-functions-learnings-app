package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.PrimaryKeyJoinColumn;
import jakarta.persistence.Table;

import java.util.Objects;
import java.util.UUID;

@Entity
@Table(name = "Progresso_Pratica")
@PrimaryKeyJoinColumn(name = "id_progresso")
public class ProgressoPratica extends Progresso {

    @Column(name = "lista_funcoes", nullable = false)
    private String listaFuncoes = "[]";

    @Column(name = "lista_dominios", nullable = false)
    private String listaDominios = "[]";

    @Column(name = "movimentos", nullable = false)
    private Integer movimentos = 0;

    @Column(name = "tentativa_uuid", unique = true, updatable = false)
    private UUID tentativaUuid;


    protected ProgressoPratica() {}

    public ProgressoPratica(Usuario usuario, AtividadePratica atividade, UUID tentativaUuid) {
        super(usuario, atividade);
        this.tentativaUuid = Objects.requireNonNull(tentativaUuid, "tentativaUuid");
    }


    public String getListaFuncoes() {
        return listaFuncoes;
    }

    public String getListaDominios() {
        return listaDominios;
    }

    public Integer getMovimentos() {
        return movimentos;
    }

    public UUID getTentativaUuid() {
        return tentativaUuid;
    }
    public void atualizarEstado(
            String listaFuncoes,
            String listaDominios,
            int movimentos
    ) {
        this.listaFuncoes = listaFuncoes;
        this.listaDominios = listaDominios;
        this.movimentos = movimentos;
    }
}