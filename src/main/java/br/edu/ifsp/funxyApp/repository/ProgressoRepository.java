package br.edu.ifsp.funxyApp.repository;

import br.edu.ifsp.funxyApp.model.Progresso;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProgressoRepository extends JpaRepository<Progresso, Long> {

    @EntityGraph(attributePaths = "atividade")
    List<Progresso> findByUsuario_IdAndDatetimeConclusaoIsNotNull(
            Long usuarioId,
            Sort sort
    );
}