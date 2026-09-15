package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;
@Entity
@Table(name = "atividade_pratica")
public class AtividadePratica extends Atividade {

    private Float dificuldade;

    @Column(name = "media_movimentos")
    private Integer mediaMovimentos;

    @Column(name = "malha_pontos")
    private String malhaPontos;

    @Column(name = "pontuacao_maxima")
    private Integer pontuacaoMaxima;

    public AtividadePratica() {
    }

    public Float getDificuldade() {
        return dificuldade;
    }

    public void setDificuldade(Float dificuldade) {
        this.dificuldade = dificuldade;
    }

    public Integer getMediaMovimentos() {
        return mediaMovimentos;
    }

    public void setMediaMovimentos(Integer mediaMovimentos) {
        this.mediaMovimentos = mediaMovimentos;
    }

    public String getMalhaPontos() {
        return malhaPontos;
    }

    public void setMalhaPontos(String malhaPontos) {
        this.malhaPontos = malhaPontos;
    }

    public Integer getPontuacaoMaxima() {
        return pontuacaoMaxima;
    }

    public void setPontuacaoMaxima(Integer pontuacaoMaxima) {
        this.pontuacaoMaxima = pontuacaoMaxima;
    }
}