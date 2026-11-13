package br.edu.ifsp.funxyApp.repository;
import br.edu.ifsp.funxyApp.model.Sessao;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
public interface SessaoRepository extends JpaRepository<Sessao, Long> {
    // Dentro da interface SessaoRepository:
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    Optional<Sessao> findByTokenHash(String tokenHash);
}
