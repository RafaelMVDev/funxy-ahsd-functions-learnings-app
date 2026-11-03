package br.edu.ifsp.funxyApp.model;
import jakarta.persistence.*;

@Entity
@Table(name = "item_loja")
public class ItemLoja extends Itens {

    private Long valor;

    public ItemLoja() {
    }

    public Long getValor() {
        return valor;
    }

    public void setValor(Long valor) {
        this.valor = valor;
    }
}