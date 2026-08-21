package br.edu.ifsp.funxyApp.controller;

import br.edu.ifsp.funxyApp.model.Usuario;
import br.edu.ifsp.funxyApp.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
public class UsuarioController {

    @Autowired
    private UsuarioRepository repository;

    @GetMapping("/")
    public String index() {
       return "";
    }

    @PostMapping("/login")
    public String adicionar() {
        return "redirect:/";
    }

}
