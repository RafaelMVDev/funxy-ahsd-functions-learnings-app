package br.edu.ifsp.funxyApp.dto.jogo;



import jakarta.validation.constraints.NotBlank;

public record NomeUsuarioDto(
        @NotBlank(message = "Informe o nome.")
        String nome
) {

    public NomeUsuarioDto {
        if (nome != null) {
            nome = nome.trim();
        }
    }
}