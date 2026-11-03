package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Progresso_Leitura")
@PrimaryKeyJoinColumn(name = "id_progresso")
public class ProgressoLeitura extends Progresso {

    @Column(name = "pagina_atual", nullable = false)
    private Integer paginaAtual = 1;

    protected ProgressoLeitura() {}

    public ProgressoLeitura(Usuario usuario, AtividadeLeitura atividade) {
        super(usuario, atividade);
    }

    public Integer getPaginaAtual() {
        return paginaAtual;
    }

    public void setPaginaAtual(int paginaAtual) {
        if (paginaAtual < 1) {
            throw new IllegalArgumentException("A página deve ser maior que zero.");
        }
        this.paginaAtual = paginaAtual;
    }
}