package br.edu.ifsp.funxyApp.controller;

import br.edu.ifsp.funxyApp.dto.jogo.NomeUsuarioDto;
import br.edu.ifsp.funxyApp.dto.jogo.SalvarConfiguracaoRequestDto;
import br.edu.ifsp.funxyApp.dto.auth.UsuarioInicialResponseDto;
import br.edu.ifsp.funxyApp.service.ProgressoUsuarioService;
import br.edu.ifsp.funxyApp.service.UsuarioService;
import jakarta.validation.Valid;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/usuario/me")
public class UsuarioController {

    private final UsuarioService usuarioService;

    public UsuarioController(UsuarioService usuarioService, ProgressoUsuarioService progressoUsuarioService) {
        this.usuarioService = usuarioService;

    }

    // GET /api/user/me
    @GetMapping
    public UsuarioInicialResponseDto buscarMeusDados(
            @AuthenticationPrincipal Long usuarioId
    ) {
        return usuarioService.carregar(usuarioId);
    }

    // PATCH /api/user/me/nome
    @PatchMapping("/nome")
    public NomeUsuarioDto alterarNome(
            @AuthenticationPrincipal Long usuarioId,
            @Valid @RequestBody NomeUsuarioDto request
    ) {
        return usuarioService.alterarNome(usuarioId, request);
    }

    // PUT /api/user/me/configuracao
    @PutMapping("/configuracao")
    public UsuarioInicialResponseDto.Preferencias salvarConfiguracao(
            @AuthenticationPrincipal Long usuarioId,
            @Valid @RequestBody SalvarConfiguracaoRequestDto request
    ) {
        return usuarioService.salvarConfiguracao(usuarioId, request);
    }
}