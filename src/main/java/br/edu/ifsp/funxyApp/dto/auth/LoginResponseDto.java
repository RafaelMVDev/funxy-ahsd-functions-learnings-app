package br.edu.ifsp.funxyApp.dto.auth;

public record LoginResponseDto(String accessToken, String refreshToken, UsuarioInicialResponseDto userDados){

};
