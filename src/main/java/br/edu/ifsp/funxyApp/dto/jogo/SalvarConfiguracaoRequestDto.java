package br.edu.ifsp.funxyApp.dto.jogo;

import br.edu.ifsp.funxyApp.model.enums.Tema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record SalvarConfiguracaoRequestDto(
        @NotNull(message = "Informe o tema.")
        Tema tema,

        @NotBlank(message = "Informe o idioma.")
        @Size(max = 60, message = "O idioma deve ter no máximo 60 caracteres.")
        String idioma,

        @NotNull(message = "Informe se as notificações estão ativadas.")
        Boolean notificacao
) {}