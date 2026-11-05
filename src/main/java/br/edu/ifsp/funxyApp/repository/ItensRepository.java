package br.edu.ifsp.funxyApp.repository;

import br.edu.ifsp.funxyApp.model.Itens;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ItensRepository extends JpaRepository<Itens, Long> {
}