package br.edu.ifsp.funxyApp.repository;

import br.edu.ifsp.funxyApp.model.ConquistaUsuarioAcessa;
import br.edu.ifsp.funxyApp.model.ConquistaUsuarioAcessa;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ConquistaUsuarioAcessaRepository extends JpaRepository<ConquistaUsuarioAcessa,Long> {
    @EntityGraph(attributePaths = "conquistas") // TIRAR ISSO PRA NN LEVAR INFORMAÇÕES DA CONQUISTA, SÓ O ID DELA TABOM
    List<ConquistaUsuarioAcessa> findByUsuario_IdOrderByDataDesc(
            Long usuarioId
    );

    boolean existsByUsuario_IdAndConquistas_Id(
            Long usuarioId,
            Long conquistaId
    );

}
