package br.edu.ifsp.funxyApp.model;
import jakarta.persistence.*;

@Entity
@Table(name = "Trilha")
public class Trilha {
    @Column(name = "id_trilha")
    private Long id;

    @Column(name = "nome_trilha")
    private String nomeTrilha;

    public Long getIdTrilha(){return id;}

}
