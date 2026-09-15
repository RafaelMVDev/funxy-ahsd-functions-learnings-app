package br.edu.ifsp.funxyApp.model;
import jakarta.persistence.*;

import br.edu.ifsp.funxy.model.Item;
@Entity
@Table(name = "item_loja")
public class ItemLoja extends Item{

    private Integer valor;

    public ItemLoja() {
    }

    public Integer getValor() {
        return valor;
    }

    public void setValor(Integer valor) {
        this.valor = valor;
    }
}