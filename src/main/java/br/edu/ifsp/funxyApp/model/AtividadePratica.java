package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;
@Entity
@Table(name = "Atividades_pratica")
public class AtividadePratica extends Atividades {

    @Column(name = "media_movimentos")
    private Integer mediaMovimentos;

    @Column(name = "malha_pontos")
    private String malhaPontos;

    @Column(name = "coordenadas_chegada")
    private String coordenadasChegada;

    /*@Column(name = "pontuacao_maxima")
    private Integer pontuacaoMaxima;* colocar pontuação máxima? */

    public AtividadePratica() {
    }


    public String getCoordenadaChegada(){ return coordenadasChegada;}

    public void setCoordenadaChegada(String coordenadasChegada){ this.coordenadasChegada = coordenadasChegada; }

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
    /*
    public Integer getPontuacaoMaxima() {
        return pontuacaoMaxima;
    }

    public void setPontuacaoMaxima(Integer pontuacaoMaxima) {
        this.pontuacaoMaxima = pontuacaoMaxima;
    }
    */

}