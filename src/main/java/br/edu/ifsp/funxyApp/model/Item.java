package br.edu.ifsp.funxy.model;

import br.edu.ifsp.funxyApp.model.enums.TipoItem;
import br.edu.ifsp.funxyApp.model.enums.EstiloItem;

import jakarta.persistence.*;

@Entity
@Table(name = "itens")
@Inheritance(strategy = InheritanceType.JOINED)
public class Item {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_item")
    private Long id;

    private String descricao;

    private String imagem;

    private String metadados;

    @Enumerated(EnumType.STRING)
    private TipoItem tipo;

    @Enumerated(EnumType.STRING)
    private EstiloItem estilo;

    public Item() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getImagem() {
        return imagem;
    }

    public void setImagem(String imagem) {
        this.imagem = imagem;
    }

    public String getMetadados() {
        return metadados;
    }

    public void setMetadados(String metadados) {
        this.metadados = metadados;
    }

    public TipoItem getTipo() {
        return tipo;
    }

    public void setTipo(TipoItem tipo) {
        this.tipo = tipo;
    }

    public EstiloItem getEstilo() {
        return estilo;
    }

    public void setEstilo(EstiloItem estilo) {
        this.estilo = estilo;
    }
}