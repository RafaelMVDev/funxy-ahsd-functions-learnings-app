package br.edu.ifsp.funxyApp.repository;


import br.edu.ifsp.funxyApp.model.Inventario;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface InventarioRepository extends JpaRepository<Inventario,Long> {
    @EntityGraph(attributePaths = "itens")
    List<Inventario> findByUsuario_IdOrderByIdAsc(Long usuarioId);

    @EntityGraph(attributePaths = "itens")
    List<Inventario> findByUsuario_IdAndEquipadoTrue(Long usuarioId);

    Optional<Inventario> findByIdAndUsuario_Id(Long inventarioId, Long usuarioId);

}
