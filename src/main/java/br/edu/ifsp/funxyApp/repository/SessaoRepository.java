package br.edu.ifsp.funxyApp.repository;
import br.edu.ifsp.funxyApp.model.Sessao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface SessaoRepository extends JpaRepository<Sessao, Long> {
}
