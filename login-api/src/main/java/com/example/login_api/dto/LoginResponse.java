package com.example.login_api.dto;

public class LoginResponse {
    private boolean sucesso;
    private String mensagem;
    private String token;

    public LoginResponse(boolean sucesso, String mensagem, String token) {
        this.sucesso = sucesso;
        this.mensagem = mensagem;
        this.token = token;
    }

    // Getters
    public boolean isSucesso() {
        return sucesso;
    }

    public String getMensagem() {
        return mensagem;
    }

    public String getToken() {
        return token;
    }
}
