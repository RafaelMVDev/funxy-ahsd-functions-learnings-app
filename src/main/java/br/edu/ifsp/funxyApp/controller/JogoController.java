package br.edu.ifsp.funxyApp.controller;


import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import br.edu.ifsp.funxyApp.dto.jogo.JogoResponseDto;
import br.edu.ifsp.funxyApp.service.JogoService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

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
}