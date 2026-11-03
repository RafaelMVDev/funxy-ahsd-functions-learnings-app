package br.edu.ifsp.funxyApp.model;
import br.edu.ifsp.funxyApp.model.enums.Tema;
import jakarta.persistence.*;


@Entity
@Table(name = "Configuracao")
public class Configuracao {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_config")
    private Long id;

    @OneToOne
    @JoinColumn(name="id_usuario")
    private Usuario usuario;

    @Enumerated(EnumType.STRING)
    private Tema tema;

    private String idioma;

    private Boolean notificacao;
    public Configuracao(){

    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Tema getTema() {
        return tema;
    }

    public void setTema(Tema tema) {
        this.tema = tema;
    }

    public String getIdioma() {
        return idioma;
    }

    public void setIdioma(String idioma) {
        this.idioma = idioma;
    }

    public Boolean getNotificacao() {
        return notificacao;
    }

    public void setNotificacao(Boolean notificacao) {
        this.notificacao = notificacao;
    }
}
