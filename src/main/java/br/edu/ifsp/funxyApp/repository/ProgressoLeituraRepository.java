package br.edu.ifsp.funxyApp.repository;

import br.edu.ifsp.funxyApp.model.ProgressoLeitura;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ProgressoLeituraRepository
        extends JpaRepository<ProgressoLeitura, Long> {

    @EntityGraph(attributePaths = "atividade")
    List<ProgressoLeitura> findByUsuario_Id(Long usuarioId);

    Optional<ProgressoLeitura> findByIdAndUsuario_Id(
            Long progressoId, Long usuarioId
    );
}