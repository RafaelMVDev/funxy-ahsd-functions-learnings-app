package br.edu.ifsp.funxyApp.model;

import jakarta.persistence.*;

@Entity
@Table(name = "Usuario_Foto")
public class UsuarioFoto {

    // Usa o mesmo ID do usuário como chave primária.
    @Id
    @Column(name = "id_usuario")
    private Long id;

    @MapsId
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @Lob
    @Column(name = "conteudo", nullable = false)
    private byte[] conteudo;

    @Column(name = "tipo_conteudo", nullable = false, length = 50)
    private String tipoConteudo;

    protected UsuarioFoto() {}

    public UsuarioFoto(
            Usuario usuario,
            byte[] conteudo,
            String tipoConteudo
    ) {
        this.usuario = usuario;
        this.conteudo = conteudo;
        this.tipoConteudo = tipoConteudo;
    }

    public Long getId() {
        return id;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public byte[] getConteudo() {
        return conteudo;
    }

    public void setConteudo(byte[] conteudo) {
        this.conteudo = conteudo;
    }

    public String getTipoConteudo() {
        return tipoConteudo;
    }

    public void setTipoConteudo(String tipoConteudo) {
        this.tipoConteudo = tipoConteudo;
    }
}