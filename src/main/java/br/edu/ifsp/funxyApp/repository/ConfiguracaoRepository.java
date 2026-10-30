package br.edu.ifsp.funxyApp.repository;



import br.edu.ifsp.funxyApp.model.Configuracao;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ConfiguracaoRepository
        extends JpaRepository<Configuracao, Long> {

    Optional<Configuracao> findByUsuarioId(Long usuarioId);
}