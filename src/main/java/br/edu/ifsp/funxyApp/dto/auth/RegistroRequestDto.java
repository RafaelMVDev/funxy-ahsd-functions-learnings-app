package br.edu.ifsp.funxyApp.dto.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import java.util.Locale;

public record RegistroRequestDto(
        @NotBlank(message = "É necessário um nome para registro")
        String nome,

        @NotBlank(message = "É necessária uma senha para registro")
        String senha,

        @NotBlank(message = "É necessário um e-mail para registro")
        @Email(message = "Formato de e-mail inválido")
        String email
) {
    // Normalização dos dados de entrada
    public RegistroRequestDto {
        if (email != null) {
            email = email.trim().toLowerCase(Locale.ROOT);
        }

        if (nome != null) {
            nome = nome.trim();
        }
    }
}