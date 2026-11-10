package br.edu.ifsp.funxyApp.repository;

import br.edu.ifsp.funxyApp.model.ProgressoPratica;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

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

    @Query("""
            select case when count(p) > 0 then true else false end
            from ProgressoPratica p
            where p.usuario.id = :usuarioId
              and p.atividade.trilha.id = :trilhaId
              and p.atividade.id <> :atividadeAtualId
              and p.datetimeConclusao is null
            """)
    boolean existeOutraPraticaAberta(
            @Param("usuarioId") Long usuarioId,
            @Param("trilhaId") Long trilhaId,
            @Param("atividadeAtualId") Long atividadeAtualId
    );

    @Query("""
            select case when count(p) > 0 then true else false end
            from ProgressoPratica p
            where p.usuario.id = :usuarioId
              and p.atividade.trilha.id = :trilhaId
              and p.atividade.numeroAtividade = :numeroAtividade
              and p.datetimeConclusao is not null
            """)
    boolean concluiuPratica(
            @Param("usuarioId") Long usuarioId,
            @Param("trilhaId") Long trilhaId,
            @Param("numeroAtividade") Integer numeroAtividade
    );

    Optional<ProgressoPratica> findByUsuario_IdAndTentativaUuid(
            Long usuarioId,
            UUID tentativaUuid
    );

}