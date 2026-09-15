package br.edu.ifsp.funxyApp.model;

import br.edu.ifsp.funxyApp.model.enums.TipoConquista;
import jakarta.persistence.*;
@Entity
@Table(name = "conquista")
public class Conquista {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_conquista")
    private Long id;

    private String nome;

    @Enumerated(EnumType.STRING)
    private TipoConquista tipo;

    @Column(name = "valor_condicao")
    private Long valorCondicao;

    private String descricao;

    public Conquista() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public TipoConquista getTipo() {
        return tipo;
    }

    public void setTipo(TipoConquista tipo) {
        this.tipo = tipo;
    }

    public Long getValorCondicao() {
        return valorCondicao;
    }

    public void setValorCondicao(Long valorCondicao) {
        this.valorCondicao = valorCondicao;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }
}
