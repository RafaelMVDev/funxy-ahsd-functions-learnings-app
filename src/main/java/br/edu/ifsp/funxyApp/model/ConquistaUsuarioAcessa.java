package br.edu.ifsp.funxyApp.model;

import java.time.LocalDateTime;
import jakarta.persistence.*;
@Entity
@Table(name = "conquista_usuario_acessa")
public class ConquistaUsuarioAcessa {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_conquista_usuario")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_usuario")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "id_conquista")
    private Conquistas conquistas;

    private LocalDateTime data;

    public ConquistaUsuarioAcessa() {
    }

    public Long getId() {
        return id;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Conquistas getConquista() {
        return conquistas;
    }

    public void setConquista(Conquistas conquistas) {
        this.conquistas = conquistas;
    }

    public LocalDateTime getData() {
        return data;
    }

    public void setData(LocalDateTime data) {
        this.data = data;
    }
}