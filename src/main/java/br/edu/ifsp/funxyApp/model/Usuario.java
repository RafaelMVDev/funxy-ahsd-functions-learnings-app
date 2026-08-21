package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Column;

@Entity
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String nome;

    @Column(nullable = false, length = 100)
    private String curso;

    @Column(nullable = false, unique = true)
    private String prontuario;

    public Usuario() {}

    public Usuario(String nome, String prontuario, String curso) {
        this.nome = nome;
        this.prontuario = prontuario;
        this.curso = curso;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getProntuario() { return prontuario; }
    public void setProntuario(String prontuario) { this.prontuario = prontuario; }
    public String getCurso() { return curso; }
    public void setCurso(String curso) { this.curso = curso; }
}
