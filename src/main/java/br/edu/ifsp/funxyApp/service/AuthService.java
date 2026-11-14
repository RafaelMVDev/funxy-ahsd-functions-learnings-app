package br.edu.ifsp.funxyApp.service;

import br.edu.ifsp.funxyApp.dto.auth.*;

import br.edu.ifsp.funxyApp.model.Sessao;
import br.edu.ifsp.funxyApp.model.Usuario;
import br.edu.ifsp.funxyApp.repository.SessaoRepository;
import br.edu.ifsp.funxyApp.repository.UsuarioRepository;
import br.edu.ifsp.funxyApp.security.TokenService;
import com.auth0.jwt.exceptions.JWTVerificationException;
import jakarta.transaction.Transactional;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.HexFormat;

@Service
public class AuthService {

    private final UsuarioRepository usuarios;
    private final SessaoRepository sessaoRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenService tokenService;
    private final UsuarioService usuarioService;



    public AuthService(
            UsuarioRepository usuarios,
            PasswordEncoder passwordEncoder, // Injetado através de setup em ConfigSeguranca
            TokenService tokenService,
            UsuarioService usuarioService,
            SessaoRepository sessaoRepository
    ) {
        this.usuarios = usuarios;
        this.passwordEncoder = passwordEncoder;
        this.tokenService = tokenService;
        this.usuarioService = usuarioService;
        this.sessaoRepository = sessaoRepository;
    }

    public LoginResponseDto login(LoginRequestDto request) {
        System.out.println("Recebendo login no service");
        System.out.println(request.email());
        System.out.println(request.senha());
        System.out.println(usuarios.findByEmail(request.email()));
        // -- Checando se o usuário existe no bdd
        Usuario usuario = usuarios.findByEmail(request.email())
                .orElseThrow(() ->
                        new BadCredentialsException("E-mail ou senha inválidos")
                );
        System.out.println(request);
        System.out.println("ACHOU EMAIL");
        // -- Se existir compara a senha com a presente no banco
        if (!passwordEncoder.matches(
                request.senha(), usuario.getSenha())) {
            throw new BadCredentialsException("E-mail ou senha inválidos");
        }
        System.out.println("SENHA NN BATEU");
        String refreshToken = tokenService.criarRefreshToken(usuario); // Colocar no bdd o refresh token, mas primeiro
        String acessToken = tokenService.criarAcessToken(usuario);

        // Gravando sessão no banco
        LocalDateTime agora = LocalDateTime.now(ZoneOffset.UTC);

        Sessao sessao = new Sessao();
        sessao.setUsuario(usuario);
        sessao.setTokenHash(hashToken(refreshToken));
        sessao.setCriadoEm(agora);
        sessao.setExpiraEm(agora.plusHours(720)); // Mesmo prazo do seu refresh: 30 dias.
        sessaoRepository.save(sessao);

        // Retornando dados da sessão
        UsuarioInicialResponseDto usuarioDados = usuarioService.carregar(usuario.getId());
        System.out.println("RETORNANDO!!!!!!!!!!!!!!!!!!");
        return new LoginResponseDto(acessToken,refreshToken,usuarioDados);
    }

    // Registro
    public  RegistroResponseDto registro(RegistroRequestDto request){
        String nome = request.nome();
        String email = request.email();
        String senha = request.senha();

        if (usuarios.findByEmail(email).isPresent()){
            return new RegistroResponseDto(false,"E-mail em uso");
        }

        if (usuarios.findByNome(nome).isPresent()){
            return new RegistroResponseDto(false,"Nome em uso");
        }

        // Registrando o usuário no BDD
        Usuario usuarioNovo = new Usuario();
        usuarioNovo.setNome(nome);
        usuarioNovo.setEmail(email);
        usuarioNovo.setSenha(passwordEncoder.encode(senha));

        usuarios.save(usuarioNovo); // SALVANDO NO BANCO DE DADOS


        return new RegistroResponseDto(true,"Conta criada!");
    }


    @Transactional
    public TokensResponseDto refresh(RefreshRequestDto request) {
        String recebido = request.refreshToken();

        // 1. Verifica assinatura, validade e tipo usando SEU método existente.
        Long usuarioId;
        try {
            usuarioId = tokenService.obterIdUsuarioRefresh(recebido);
        } catch (JWTVerificationException | NumberFormatException e) {
            throw refreshInvalido();
        }

        // 2. Confere se esse ainda é o refresh atual da sessão.
        Sessao sessao = sessaoRepository.findByTokenHash(hashToken(recebido))
                .orElseThrow(this::refreshInvalido);

        if (sessao.getRevogadoEm() != null
                || !sessao.getExpiraEm().isAfter(LocalDateTime.now(ZoneOffset.UTC))
                || !usuarioId.equals(sessao.getUsuario().getId())) {
            throw refreshInvalido();
        }

        // 3. Gera o novo par e substitui o hash antigo no banco.
        Usuario usuario = sessao.getUsuario();
        String novoRefresh = tokenService.criarRefreshToken(usuario);
        String novoAccess = tokenService.criarAcessToken(usuario);

        sessao.setTokenHash(hashToken(novoRefresh));
        sessaoRepository.save(sessao);

        return new TokensResponseDto(novoAccess, novoRefresh);
    }

    private ResponseStatusException refreshInvalido() {
        return new ResponseStatusException(
                HttpStatus.UNAUTHORIZED, "Refresh token inválido ou expirado."
        );
    }

    private String hashToken(String token) {
        try {
            byte[] hash = MessageDigest.getInstance("SHA-256")
                    .digest(token.getBytes(StandardCharsets.UTF_8));

            return HexFormat.of().formatHex(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException("SHA-256 indisponível.", e);
        }
    }
}