package br.edu.ifsp.funxyApp.dto.auth;

import jakarta.validation.constraints.NotBlank;

public record RefreshRequestDto(
        @NotBlank(message = "Informe o refresh token.")
        String refreshToken
) {}