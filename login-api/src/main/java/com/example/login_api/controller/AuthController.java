package com.example.login_api.controller;

import com.example.login_api.dto.CadastroRequest;
import com.example.login_api.dto.LoginRequest;
import com.example.login_api.dto.LoginResponse;
import com.example.login_api.dto.*;
import com.example.login_api.model.Usuario;
import com.example.login_api.repository.UsuarioRepository;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*") // Permite chamadas vindas de outras origens (como o Godot)
public class AuthController {

    @Autowired
    private UsuarioRepository usuarioRepository; // Injeta o acesso ao banco de dados H2

    // --- ROTA DE CADASTRO ---
    @PostMapping("/cadastro")
    public ResponseEntity<LoginResponse> cadastrar(@RequestBody CadastroRequest request) {

        // 1. Validação de campos vazios
        if (request.getNome() == null || request.getNome().isBlank() ||
                request.getEmail() == null || request.getEmail().isBlank() ||
                request.getSenha() == null || request.getSenha().isBlank()) {

            return ResponseEntity.badRequest().body(
                    new LoginResponse(false, "Todos os campos devem ser preenchidos!", null)
            );
        }

        // 2. Consulta o banco H2 para ver se o e-mail já existe
        if (usuarioRepository.existsByEmail(request.getEmail())) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(
                    new LoginResponse(false, "Este e-mail já está em uso!", null)
            );
        }

        // 3. Salva o novo usuário no Banco de Dados H2
        Usuario novoUsuario = new Usuario(request.getNome(), request.getEmail(), request.getSenha());
        usuarioRepository.save(novoUsuario);

        return ResponseEntity.status(HttpStatus.CREATED).body(
                new LoginResponse(true, "Conta criada com sucesso!", "token_provisorio_h2")
        );
    }

    // --- ROTA DE LOGIN ---
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {

        // 1. Busca o usuário no banco de dados H2 pelo e-mail enviado
        Optional<Usuario> usuarioOpt = usuarioRepository.findByEmail(request.getEmail());

        // 2. Verifica se o usuário existe e se a senha confere
        if (usuarioOpt.isPresent()) {
            Usuario usuario = usuarioOpt.get();

            if (usuario.getSenha().equals(request.getSenha())) {
                return ResponseEntity.ok(
                        new LoginResponse(true, "Login realizado com sucesso!", "token_sessao_" + usuario.getId())
                );
            }
        }

        // 3. Se o e-mail não existir ou a senha estiver incorreta
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(
                new LoginResponse(false, "E-mail ou senha incorretos.", null)
        );
    }

}
