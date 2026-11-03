package br.edu.ifsp.funxyApp.dto.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record RegistroResponseDto(String mensagem) {

    // Validação de entrada no nivel de dto
    public RegistroResponseDto {

    }
}