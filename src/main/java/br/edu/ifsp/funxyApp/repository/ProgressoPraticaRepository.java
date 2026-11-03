package br.edu.ifsp.funxyApp.repository;

import br.edu.ifsp.funxyApp.model.ProgressoPratica;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProgressoPraticaRepository
        extends JpaRepository<ProgressoPratica, Long> {

    @EntityGraph(attributePaths = "atividade")
    List<ProgressoPratica> findByUsuario_Id(Long usuarioId);

    Optional<ProgressoPratica> findByIdAndUsuario_Id(
            Long progressoId, Long usuarioId
    );
}