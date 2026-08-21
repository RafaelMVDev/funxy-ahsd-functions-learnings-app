package br.edu.ifsp.funxyApp.repository;

import br.edu.ifsp.funxyApp.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
    List<Usuario> findByNomeContainingIgnoreCase(String nome);

    Usuario findFirstByProntuarioIgnoreCase(String prontuario);
}
