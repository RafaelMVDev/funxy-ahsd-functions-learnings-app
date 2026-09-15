package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;
@Entity
@Table(name = "atividade_leitura")
public class AtividadeLeitura extends Atividade {

    private String texto;

    private String imagens;

    public AtividadeLeitura() {
    }

    public String getTexto() {
        return texto;
    }

    public void setTexto(String texto) {
        this.texto = texto;
    }

    public String getImagens() {
        return imagens;
    }

    public void setImagens(String imagens) {
        this.imagens = imagens;
    }
}