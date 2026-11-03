package br.edu.ifsp.funxyApp.repository;

import br.edu.ifsp.funxyApp.model.ConquistaUsuarioAcessa;
import br.edu.ifsp.funxyApp.model.ConquistaUsuarioAcessa;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ConquistaUsuarioAcessaRepository extends JpaRepository<ConquistaUsuarioAcessa,Long> {
    @EntityGraph(attributePaths = "conquistas")
    List<ConquistaUsuarioAcessa> findByUsuario_IdOrderByDataDesc(
            Long usuarioId
    );

    boolean existsByUsuario_IdAndConquistas_Id(
            Long usuarioId,
            Long conquistaId
    );

}
