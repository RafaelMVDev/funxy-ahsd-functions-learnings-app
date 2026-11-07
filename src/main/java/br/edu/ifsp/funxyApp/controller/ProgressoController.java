package br.edu.ifsp.funxyApp.controller;

import br.edu.ifsp.funxyApp.dto.atividade.SalvarProgressoPraticaRequestDto;
import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto;
import br.edu.ifsp.funxyApp.service.ProgressoUsuarioService;
import jakarta.validation.Valid;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/progresso")
public class ProgressoController {

    private final ProgressoUsuarioService progressoUsuarioService;

    public ProgressoController(ProgressoUsuarioService progressoUsuarioService) {
        this.progressoUsuarioService = progressoUsuarioService;
    }

    @PostMapping("/pratica/{atividadeId}/salvar")
    public TrilhaProgressoDto.Tentativa salvarPratica(
            @AuthenticationPrincipal Long usuarioId,
            @PathVariable Long atividadeId,
            @Valid @RequestBody SalvarProgressoPraticaRequestDto request
    ) {
        return progressoUsuarioService.salvarPratica(
                usuarioId, atividadeId, request
        );
    }
}