package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;
@Entity
@Table(name = "item_passe_batalha")
public class ItemPasseBatalha {

    @Column(name= "xp_necessario")
    private long xpNecessario;

    public ItemPasseBatalha(){

    }
    public Long getXpNecessario() {
        return xpNecessario;
    }

    public void setXpNecessario(Long xpNecessario) {
        this.xpNecessario = xpNecessario;
    }

}
