package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;

@Entity
@Table(name = "inventario")
public class Inventario {

    @Id
    @Column(name="id_inventario")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_usuario")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "id_item")
    private Itens itens;

    private Boolean equipado;

    public Inventario() {
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

    public Itens getItem() {
        return itens;
    }

    public void setItem(Itens itens) {
        this.itens = itens;
    }

    public Boolean getEquipado() {
        return equipado;
    }

    public void setEquipado(Boolean equipado) {
        this.equipado = equipado;
    }
}