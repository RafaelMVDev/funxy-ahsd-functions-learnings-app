package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Progresso")
public class Progresso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_progresso")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id_usuario")
    private Usuario usuario;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id_atividade")
    private Atividades atividade;

    @Column(name = "datetime_inicio")
    private LocalDateTime datetimeInicio;

    @Column(name = "datetime_conclusao")
    private LocalDateTime datetimeConclusao;

    public Progresso() {}

    public Long getId() { return id; }
    public Usuario getUsuario() { return usuario; }
    public Atividades getAtividade() { return atividade; }
    public LocalDateTime getDatetimeInicio() { return datetimeInicio; }
    public LocalDateTime getDatetimeConclusao() { return datetimeConclusao; }
}
