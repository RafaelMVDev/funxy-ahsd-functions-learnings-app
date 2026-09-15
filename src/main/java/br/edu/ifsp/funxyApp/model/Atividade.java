package br.edu.ifsp.funxyApp.model;
import br.edu.ifsp.funxyApp.model.enums.TipoAtividade;
import jakarta.persistence.*;
@Entity
@Table(name = "atividade")
@Inheritance(strategy = InheritanceType.JOINED)
public class Atividade {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_atividade")
    private Long id;

    @Column(name = "xp_base")
    private Long xpBase;

    @Column(name = "moeda_base")
    private Integer moedaBase;

    @Column(name = "numero_atividade")
    private Integer numeroAtividade;

    private String descricao;

    private String titulo;

    @Column(name = "id_trilha")
    private Integer idTrilha;

    @Enumerated(EnumType.STRING)
    private TipoAtividade tipo;

    public Atividade() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getXpBase() {
        return xpBase;
    }

    public void setXpBase(Long xpBase) {
        this.xpBase = xpBase;
    }

    public Integer getMoedaBase() {
        return moedaBase;
    }

    public void setMoedaBase(Integer moedaBase) {
        this.moedaBase = moedaBase;
    }

    public Integer getNumeroAtividade() {
        return numeroAtividade;
    }

    public void setNumeroAtividade(Integer numeroAtividade) {
        this.numeroAtividade = numeroAtividade;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public Integer getIdTrilha() {
        return idTrilha;
    }

    public void setIdTrilha(Integer idTrilha) {
        this.idTrilha = idTrilha;
    }

    public TipoAtividade getTipo() {
        return tipo;
    }

    public void setTipo(TipoAtividade tipo) {
        this.tipo = tipo;
    }
}