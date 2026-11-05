package br.edu.ifsp.funxyApp.dto.auth;

public record TokensResponseDto(
        String accessToken,
        String refreshToken
) {}