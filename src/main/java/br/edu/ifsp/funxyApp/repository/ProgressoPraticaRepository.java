package br.edu.ifsp.funxyApp.repository;

import br.edu.ifsp.funxyApp.model.ProgressoPratica;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;

import java.util.List;
import java.util.Optional;

public interface ProgressoPraticaRepository
        extends JpaRepository<ProgressoPratica, Long> {

    @EntityGraph(attributePaths = "atividade")
    List<ProgressoPratica> findByUsuario_Id(Long usuarioId);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    Optional<ProgressoPratica> findByIdAndUsuario_Id(
            Long progressoId, Long usuarioId
    );

    Optional<ProgressoPratica> findByUsuario_IdAndAtividade_IdAndDatetimeConclusaoIsNull(
            Long usuarioId,
            Long atividadeId
    );

}