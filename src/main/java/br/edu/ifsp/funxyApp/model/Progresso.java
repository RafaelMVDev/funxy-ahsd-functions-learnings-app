package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Progresso")
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Progresso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_progresso")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id_atividade", nullable = false)
    private Atividades atividade;

    @Column(name = "datetime_inicio")
    private LocalDateTime datetimeInicio;

    @Column(name = "datetime_conclusao")
    private LocalDateTime datetimeConclusao;

    protected Progresso() {
        // Construtor usado pelo JPA.
    }

    protected Progresso(Usuario usuario, Atividades atividade) {
        this.usuario = java.util.Objects.requireNonNull(usuario);
        this.atividade = java.util.Objects.requireNonNull(atividade);
        this.datetimeInicio = LocalDateTime.now();
    }

    public void concluir() {
        if (datetimeConclusao == null) {
            datetimeConclusao = LocalDateTime.now();
        }
    }

    public Long getId() {
        return id;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public Atividades getAtividade() {
        return atividade;
    }

    public LocalDateTime getDatetimeInicio() {
        return datetimeInicio;
    }

    public LocalDateTime getDatetimeConclusao() {
        return datetimeConclusao;
    }
}