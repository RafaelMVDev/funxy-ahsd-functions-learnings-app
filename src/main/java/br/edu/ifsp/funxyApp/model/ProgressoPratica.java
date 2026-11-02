package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Progresso_Pratica")
@PrimaryKeyJoinColumn(name = "id_progresso")
public class ProgressoPratica extends Progresso {

    @Column(name = "posicao_atual")
    private String posicaoAtual;

    @Column(name = "movimentos", nullable = false)
    private Integer movimentos = 0;

    protected ProgressoPratica() {}

    public ProgressoPratica(Usuario usuario, AtividadePratica atividade) {
        super(usuario, atividade);
    }

    public String getPosicaoAtual() {
        return posicaoAtual;
    }

    public Integer getMovimentos() {
        return movimentos;
    }

    public void atualizarCheckpoint(String posicaoAtual, int movimentos) {
        if (movimentos < 0) {
            throw new IllegalArgumentException("Movimentos não podem ser negativos.");
        }
        this.posicaoAtual = posicaoAtual;
        this.movimentos = movimentos;
    }
}