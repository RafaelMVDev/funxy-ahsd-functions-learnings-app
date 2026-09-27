package com.example.login_api.model;

import jakarta.persistence.*;

@Entity
@Table(name = "tb_usuarios") // Nome da tabela no H2
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id; // Chave primária (gerada automaticamente 1, 2, 3...)

    @Column(nullable = false)
    private String nome;

    @Column(nullable = false, unique = true) // E-mail obrigatório e único!
    private String email;

    @Column(nullable = false)
    private String senha;

    // Construtor vazio (obrigatório para o JPA)
    public Usuario() {}

    // Construtor utilitário
    public Usuario(String nome, String email, String senha) {
        this.nome = nome;
        this.email = email;
        this.senha = senha;
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getSenha() { return senha; }
    public void setSenha(String senha) { this.senha = senha; }
}
