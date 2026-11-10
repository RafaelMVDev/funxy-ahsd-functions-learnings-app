package br.edu.ifsp.funxyApp.repository;

import br.edu.ifsp.funxyApp.model.Atividades;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface AtividadesRepository extends JpaRepository<Atividades, Long> {

    List<Atividades> findAllByOrderByTrilha_IdAscNumeroAtividadeAsc();


    /* Busca a atividade pratica mais recente concluida (ignorando atividades de leitura da verificação*/
    @Query("""
    select max(p.numeroAtividade)
    from AtividadePratica p
    where p.trilha.id = :trilhaId
      and p.numeroAtividade < :numeroAtual
    """)
    Optional<Integer> buscarNumeroPraticaAnterior(
            @Param("trilhaId") Long trilhaId,
            @Param("numeroAtual") Integer numeroAtual
    );
}