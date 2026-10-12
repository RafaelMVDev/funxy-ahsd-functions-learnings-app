package br.edu.ifsp.funxyApp.service;

import br.edu.ifsp.funxyApp.dto.*;
import br.edu.ifsp.funxyApp.model.Usuario;
import br.edu.ifsp.funxyApp.repository.UsuarioRepository;
import br.edu.ifsp.funxyApp.security.TokenService;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UsuarioRepository usuarios;
    private final PasswordEncoder passwordEncoder;
    private final TokenService tokenService;

    public AuthService(
            UsuarioRepository usuarios,
            PasswordEncoder passwordEncoder,
            TokenService tokenService
    ) {
        this.usuarios = usuarios;
        this.passwordEncoder = passwordEncoder;
        this.tokenService = tokenService;
    }

    public LoginResponse login(LoginRequest request) {
        Usuario usuario = usuarios.findByEmail(request.email())
                .orElseThrow(() ->
                        new BadCredentialsException("E-mail ou senha inválidos"));

        if (!passwordEncoder.matches(
                request.senha(), usuario.getSenha())) {
            throw new BadCredentialsException("E-mail ou senha inválidos");
        }

        String refreshToken = tokenService.criarRefreshToken(usuario);
        String acessToken = tokenService.criarAcessToken(usuario);
        return new LoginResponse(acessToken,refreshToken, usuario.getNome());
    }
}