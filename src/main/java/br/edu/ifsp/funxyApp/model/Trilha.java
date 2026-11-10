package br.edu.ifsp.funxyApp.model;
import jakarta.persistence.*;

@Entity
@Table(name = "Trilha")
public class Trilha {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_trilha")
    private Long id;

    @Column(name = "nome_trilha")
    private String nomeTrilha;

    @Column(name = "numero_trilha")
    private String numeroTrilha;

    public Long getIdTrilha(){return id;}

    public String getNumeroTrilha(){return numeroTrilha;}

}
