package com.example.login_api.repository;

import com.example.login_api.model.Usuario;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    // O Spring gera o SQL automaticamente baseado no nome do metodo!
    boolean existsByEmail(String email);

    Optional<Usuario> findByEmail(String email);
}
