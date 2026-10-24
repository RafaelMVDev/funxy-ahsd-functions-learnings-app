package br.edu.ifsp.funxyApp.service;

import br.edu.ifsp.funxyApp.dto.auth.*;

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
            PasswordEncoder passwordEncoder, // Injetado através de setup em ConfigSeguranca
            TokenService tokenService
    ) {
        this.usuarios = usuarios;
        this.passwordEncoder = passwordEncoder;
        this.tokenService = tokenService;
    }

    public LoginResponseDto login(LoginRequestDto request) {
        System.out.println("Recebendo login no service");

        // -- Checando se o usuário existe no bdd
        Usuario usuario = usuarios.findByEmail(request.email())
                .orElseThrow(() ->
                        new BadCredentialsException("E-mail ou senha inválidos")
                );
        // -- Se existir compara a senha com a presente no banco
        if (!passwordEncoder.matches(
                request.senha(), usuario.getSenha())) {
            throw new BadCredentialsException("E-mail ou senha inválidos");
        }

        String refreshToken = tokenService.criarRefreshToken(usuario); // Colocar no bdd o refresh token, mas primeiro
        String acessToken = tokenService.criarAcessToken(usuario);
        System.out.println("RETORNANDO!!!!!!!!!!!!!!!!!!");
        return new LoginResponseDto(acessToken,refreshToken, usuario.getNome());
    }

    // Registro
    public RegistroResponseDto register(RegistroRequestDto request){
        String nome = request.nome();
        String email = request.email();
        String senha = request.senha();

        if (usuarios.findByEmail(email).isPresent()){
            return new RegistroResponseDto("e-mail em uso!");
        }

        if (usuarios.findByNome(nome).isPresent()){
            return new RegistroResponseDto("nome em uso!");
        }

        Usuario usuarioNovo = Usuario();
        return new RegistroResponseDto("Conta criada!");
    }
}