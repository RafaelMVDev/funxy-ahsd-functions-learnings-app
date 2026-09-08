package br.edu.ifsp.funxyApp.model;
import jakarta.persistence.*;

import java.math.BigInteger;

@Entity
@Table(name = "usuario")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name="email")
    private String email;

    @Column(name="nome")
    private String nome;

    @Column(name="senha_hash")
    private String senhaHash;

    @Column(name="sequencia")
    private Integer sequencia;

    @Column(name="moedas")
    private Long moedas;

    @Column(name="xp")
    private Long xp;


    public Usuario() {}

    public Usuario(String nome, String email, String senhaHash, Integer sequencia, Long moedas, Long xp) {
        this.nome = nome;
        this.email = email;
        this.senhaHash = senhaHash;
        this.sequencia = sequencia;
        this.moedas = moedas;
        this.xp = xp;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getSenhaHash() {
        return senhaHash;
    }

    public void setSenhaHash(String senhaHash) {
        this.senhaHash = senhaHash;
    }

    public Integer getSequencia() {
        return sequencia;
    }

    public void setSequencia(Integer sequencia) {
        this.sequencia = sequencia;
    }

    public Long getMoedas() {
        return moedas;
    }

    public void setMoedas(Long moedas) {
        this.moedas = moedas;
    }

    public Long getXp() {
        return xp;
    }

    public void setXp(Long xp) {
        this.xp = xp;
    }
}
