package br.edu.ifsp.funxyApp.controller;

import br.edu.ifsp.funxyApp.dto.auth.LoginRequestDto;
import br.edu.ifsp.funxyApp.dto.auth.LoginResponseDto;

import br.edu.ifsp.funxyApp.dto.auth.RegistroRequestDto;
import br.edu.ifsp.funxyApp.dto.auth.RegistroResponseDto;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
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
    @ResponseStatus(HttpStatus.CREATED) // TODO: TAPA BURACO, DEIXAR MAIS SOFISTICADO DEPOIS
    public RegistroResponseDto registro(@Valid @RequestBody RegistroRequestDto request) {

        return authService.register(request);

    }


}


