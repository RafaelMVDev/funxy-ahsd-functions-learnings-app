package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;
@Entity
@Table(name = "Atividades_pratica")
public class AtividadePratica extends Atividades {

    @Column(name = "media_movimentos")
    private Integer mediaMovimentos;

    @Column(name = "colisoes_malha")
    private String colisoesMalha;


    /*@Column(name = "pontuacao_maxima")
    private Integer pontuacaoMaxima;* colocar pontuação máxima? */

    public AtividadePratica() {
    }


    public Integer getMediaMovimentos() {
        return mediaMovimentos;
    }

    public void setMediaMovimentos(Integer mediaMovimentos) {
        this.mediaMovimentos = mediaMovimentos;
    }

    public String getColisoesMalha() {
        return colisoesMalha;
    }

    public void setColisoesMalhas(String colisoes) {
        this.colisoesMalha = colisoes;
    }
    /*
    public Integer getPontuacaoMaxima() {
        return pontuacaoMaxima;
    }

    public void setPontuacaoMaxima(Integer pontuacaoMaxima) {
        this.pontuacaoMaxima = pontuacaoMaxima;
    }
    */

}