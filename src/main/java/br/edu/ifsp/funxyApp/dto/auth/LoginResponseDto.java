package br.edu.ifsp.funxyApp.dto.auth;

public record LoginResponseDto(String acessToken, String refreshToken, String nome){};
