package br.edu.ifsp.funxyApp.service;

import br.edu.ifsp.funxyApp.dto.auth.UsuarioInicialResponseDto;
import br.edu.ifsp.funxyApp.dto.trilha.TrilhaProgressoDto;
import br.edu.ifsp.funxyApp.model.Usuario;
import br.edu.ifsp.funxyApp.model.Configuracao;
import br.edu.ifsp.funxyApp.repository.*;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;
import br.edu.ifsp.funxyApp.dto.jogo.NomeUsuarioDto;
import br.edu.ifsp.funxyApp.dto.jogo.SalvarConfiguracaoRequestDto;

import java.util.List;

@Service
public class UsuarioService {

    private final UsuarioRepository usuarios;
    private final ConfiguracaoRepository configuracoes;
    private final InventarioRepository inventarios;
    private final ConquistaUsuarioAcessaRepository conquistas;
    // Services

    private final ProgressoUsuarioService progressoUsuarioService;

    public UsuarioService(
            UsuarioRepository usuarios,
            ConfiguracaoRepository configuracoes,
            InventarioRepository inventarios,
            ConquistaUsuarioAcessaRepository conquistas,
            ProgressoUsuarioService progressoUsuarioService
    ) {
        this.usuarios = usuarios;
        this.configuracoes = configuracoes;
        this.inventarios = inventarios;
        this.conquistas = conquistas;
        this.progressoUsuarioService = progressoUsuarioService;
    }
    @Transactional(readOnly = true)
    public UsuarioInicialResponseDto carregar(Long usuarioId) {
        Usuario usuario = usuarios.findById(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND,
                        "Usuário não encontrado."
                ));

        return carregar(usuario);
    }


    @Transactional(readOnly = true)
    public UsuarioInicialResponseDto carregar(Usuario usuario) {


        var perfil = new UsuarioInicialResponseDto.Perfil(
                usuario.getId(),
                usuario.getNome(),
                usuario.getEmail(),
                usuario.getSequencia(),
                usuario.getMoedas(),
                usuario.getXp()
        );

        Long usuarioId = usuario.getId();
        var configuracao = configuracoes.findByUsuario_Id(usuarioId)
                .map(config -> new UsuarioInicialResponseDto.Preferencias(
                        nomeEnum(config.getTema()),
                        config.getIdioma(),
                        config.getNotificacao()
                ))
                .orElse(null);

        var itens = inventarios.findByUsuario_IdOrderByIdAsc(usuarioId)
                .stream()
                .map(registro -> {
                    var item = registro.getItem();

                    return new UsuarioInicialResponseDto.ItemInventario(
                            registro.getId(),
                            item.getId(),
                            item.getDescricao(),
                            item.getMetadados(),
                            nomeEnum(item.getTipo()),
                            nomeEnum(item.getEstilo()),
                            registro.getEquipado()
                    );
                })
                .toList();

        var desbloqueadas = conquistas.findByUsuario_IdOrderByDataDesc(usuarioId)
                .stream()
                .map(registro -> new UsuarioInicialResponseDto.ConquistaDesbloqueada(
                        registro.getConquista().getId(),
                        registro.getData()
                ))
                .toList();
        List<TrilhaProgressoDto> trilhas =
                progressoUsuarioService.buscarTrilhas(usuario.getId());

        return new UsuarioInicialResponseDto(
                perfil,
                configuracao,
                itens,
                desbloqueadas,
                trilhas
        );
    }

    private static String nomeEnum(Enum<?> valor) {
        return valor == null ? null : valor.name();
    }

    // ALTERAÇÃO DOS DADOS DO JOGADOR
    @Transactional
    public NomeUsuarioDto alterarNome(Long usuarioId, NomeUsuarioDto request) {
        Usuario usuario = usuarios.findById(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuário não encontrado."
                ));

        boolean nomeEmUso = usuarios.findByNome(request.nome())
                .filter(outro -> !outro.getId().equals(usuarioId))
                .isPresent();

        if (nomeEmUso) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Nome em uso.");
        }

        usuario.setNome(request.nome());
        usuarios.save(usuario);

        return new NomeUsuarioDto(usuario.getNome());
    }

    @Transactional
    public UsuarioInicialResponseDto.Preferencias salvarConfiguracao(
            Long usuarioId,
            SalvarConfiguracaoRequestDto request
    ) {
        Usuario usuario = usuarios.findById(usuarioId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Usuário não encontrado."
                ));

        Configuracao config = configuracoes.findByUsuario_Id(usuarioId)
                .orElseGet(Configuracao::new);

        config.setUsuario(usuario);
        config.setTema(request.tema());
        config.setIdioma(request.idioma().trim());
        config.setNotificacao(request.notificacao());

        configuracoes.save(config);

        return new UsuarioInicialResponseDto.Preferencias(
                nomeEnum(config.getTema()),
                config.getIdioma(),
                config.getNotificacao()
        );
    }
}