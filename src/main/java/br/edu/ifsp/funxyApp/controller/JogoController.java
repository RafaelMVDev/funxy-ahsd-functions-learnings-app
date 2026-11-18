package br.edu.ifsp.funxyApp.controller;


import br.edu.ifsp.funxyApp.dto.jogo.RankingJogadorDto;
import br.edu.ifsp.funxyApp.dto.jogo.RankingJogadoresFotoDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import br.edu.ifsp.funxyApp.dto.jogo.JogoResponseDto;
import br.edu.ifsp.funxyApp.service.JogoService;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/jogo")
public class JogoController {

    private final JogoService jogoService;

    public JogoController(JogoService jogoService) {
        this.jogoService = jogoService;
    }

    // GET /jogo
    @GetMapping
    public JogoResponseDto buscarTudo() {
        System.out.println("BUSCANDO!");
        JogoResponseDto dados = jogoService.carregarTudo();
        System.out.println(dados);
        return jogoService.carregarTudo();
    }

    // GET /jogo/trilhas
    @GetMapping("/trilhas")
    public List<JogoResponseDto.Trilha> buscarTrilhas() {
        return jogoService.buscarTrilhas();
    }

    // GET /jogo/conquistas
    @GetMapping("/conquistas")
    public List<JogoResponseDto.Conquista> buscarConquistas() {
        return jogoService.buscarConquistas();
    }

    // GET /jogo/itens
    @GetMapping("/itens")
    public List<JogoResponseDto.Item> buscarItens() {
        return jogoService.buscarItens();
    }

    // GET /jogo/ranking
    @GetMapping("/ranking")
    public List<RankingJogadorDto> buscarRanking() {
        return jogoService.buscarRanking();
    }


        // Endpoint separado apenas para as fotos do ranking
    @GetMapping("/ranking/fotos")
    public List<RankingJogadoresFotoDto> buscarFotosEmLote(@RequestParam List<Long> ids) {
        System.out.println("Buscando fotos!");
        return jogoService.obterFotosPorIdsEmLote(ids);
    }

}