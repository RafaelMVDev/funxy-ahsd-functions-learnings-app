package br.edu.ifsp.funxyApp.dto.auth;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record RegistroRequestDto(
        @NotBlank(message = "É necessario um nome para registro") String nome,
        @NotBlank(message = "É necessario uma senha para registro") String senha,
        @Email @NotBlank(message = "É necessario um email para registro") String email ) {

    // Validação de entrada no nivel de dto
    public RegistroRequestDto {
        if (email != null) {
            email = email.trim().toLowerCase();
        }

        if (nome != null){
            nome = nome.trim();
        }
    }
}
