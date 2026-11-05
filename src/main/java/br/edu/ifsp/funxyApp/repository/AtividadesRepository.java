package br.edu.ifsp.funxyApp.repository;

import br.edu.ifsp.funxyApp.model.Atividades;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AtividadesRepository extends JpaRepository<Atividades, Long> {

    List<Atividades> findAllByOrderByIdTrilhaAscNumeroAtividadeAsc();
}