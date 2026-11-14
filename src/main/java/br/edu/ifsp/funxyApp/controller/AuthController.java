package br.edu.ifsp.funxyApp.controller;

import br.edu.ifsp.funxyApp.dto.auth.*;

import jakarta.validation.Valid;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import br.edu.ifsp.funxyApp.service.AuthService;


@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    } // Injeção de dependência aqui, authService é passado na inicialização do controller ( também tem conceito de IoC), o Spring faz isso automaticamente


    // ===== LOGIN ======
    @PostMapping("/login")
    public LoginResponseDto login(@RequestBody LoginRequestDto request) {

        System.out.println("RECEBENDO REQUISIÇÃO");
            return authService.login(request);
    }


    // ===== REGSITRO ======
    @PostMapping("/registro")

    public ResponseEntity<RegistroResponseDto> registro(@Valid @RequestBody RegistroRequestDto request) {
        RegistroResponseDto resposta = authService.registro(request);

        HttpStatus status = resposta.sucesso()
                ? HttpStatus.CREATED     // se for true: 201
                : HttpStatus.CONFLICT;   // se for false: 409

        return ResponseEntity.status(status).body(resposta);

    }

    /* Rota para revalidar tokens */
    @PostMapping("/atualizarTokens")
    public ResponseEntity<TokensResponseDto> refresh(
            @Valid @RequestBody RefreshRequestDto request
    ) {
        TokensResponseDto tokens = authService.atualizarTokens(request);

        return ResponseEntity.ok()
                .cacheControl(CacheControl.noStore())
                .body(tokens);
    }
}


