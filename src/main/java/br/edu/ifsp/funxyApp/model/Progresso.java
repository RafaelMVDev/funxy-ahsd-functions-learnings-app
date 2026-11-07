package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import br.edu.ifsp.funxyApp.model.enums.StatusAtividade;

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
    /*
    @Column(name = "datetime_inicio")
    private LocalDateTime datetimeInicio;
    */
    @Column(name = "datetime_conclusao")
    private LocalDateTime datetimeConclusao;

    @Enumerated(EnumType.STRING)
    @Column(name ="status")
    private StatusAtividade status;

    protected Progresso() {
        // Construtor usado pelo JPA.
    }

    protected Progresso(Usuario usuario, Atividades atividade) {
        this.usuario = java.util.Objects.requireNonNull(usuario);
        this.atividade = java.util.Objects.requireNonNull(atividade);

    }

    public void concluir() {
        if (datetimeConclusao == null) {
            datetimeConclusao = LocalDateTime.now();
            status = StatusAtividade.concluido;
        }
    }

    public Long getId() {
        return id;
    }

    public StatusAtividade getStatus(){
        return status;
    }


    public Usuario getUsuario() {
        return usuario;
    }

    public Atividades getAtividade() {
        return atividade;
    }

    public LocalDateTime getDatetimeConclusao() {
        return datetimeConclusao;
    }
}