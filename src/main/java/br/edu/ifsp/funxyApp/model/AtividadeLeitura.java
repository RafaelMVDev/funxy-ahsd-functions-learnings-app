package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;
@Entity
@Table(name = "Atividades_leitura")
public class AtividadeLeitura extends Atividades {

    private String textos;

    private String imagens;

    public AtividadeLeitura() {
    }

    public String getTexto() {
        return textos;
    }

    public void setTexto(String texto) {
        this.textos = texto;
    }

    public String getImagens() {
        return imagens;
    }

    public void setImagens(String imagens) {
        this.imagens = imagens;
    }
}