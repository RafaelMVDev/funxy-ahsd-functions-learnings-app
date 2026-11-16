package br.edu.ifsp.funxyApp.controller;

import br.edu.ifsp.funxyApp.dto.jogo.NomeUsuarioDto;
import br.edu.ifsp.funxyApp.dto.jogo.SalvarConfiguracaoRequestDto;
import br.edu.ifsp.funxyApp.dto.auth.UsuarioInicialResponseDto;
import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto;
import br.edu.ifsp.funxyApp.dto.usuario.AtualizarMoedasRequestDto;
import br.edu.ifsp.funxyApp.dto.usuario.AtualizarXpRequestDto;
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

import java.util.List;

@RestController
@RequestMapping("/api/usuario/me")
public class UsuarioController {

    private final UsuarioService usuarioService;
    private final ProgressoUsuarioService progressoUsuarioService;
    public UsuarioController(UsuarioService usuarioService, ProgressoUsuarioService progressoUsuarioService) {
        this.usuarioService = usuarioService;
        this.progressoUsuarioService = progressoUsuarioService;

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

    @GetMapping("/progresso")
    public List<TrilhaProgressoDto> retornarTrilhas(
            @AuthenticationPrincipal Long usuarioId
    ){
        System.out.println("OIIDIADOASDIAI");
        return progressoUsuarioService.buscarTrilhas(usuarioId);
    }

    // GET /api/usuario/me/perfil
    @GetMapping("/perfil")
    public UsuarioInicialResponseDto.Perfil buscarPerfil(
            @AuthenticationPrincipal Long usuarioId
    ) {
        return usuarioService.buscarPerfil(usuarioId);
    }

    // PATCH /api/usuario/me/moedas
    @PatchMapping("/moedas")
    public UsuarioInicialResponseDto.Perfil atualizarMoedas(
            @AuthenticationPrincipal Long usuarioId,
            @Valid @RequestBody AtualizarMoedasRequestDto request
    ) {
        return usuarioService.atualizarMoedas(usuarioId, request);
    }

    // PATCH /api/usuario/me/xp
    @PatchMapping("/xp")
    public UsuarioInicialResponseDto.Perfil atualizarXp(
            @AuthenticationPrincipal Long usuarioId,
            @Valid @RequestBody AtualizarXpRequestDto request
    ) {
        return usuarioService.atualizarXp(usuarioId, request);
    }

}