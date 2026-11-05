package br.edu.ifsp.funxyApp.security;

import org.springframework.web.filter.OncePerRequestFilter;

import com.auth0.jwt.exceptions.JWTVerificationException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

public class JwtFiltroAutenticacao extends OncePerRequestFilter {

    private final TokenService tokenService;

    public JwtFiltroAutenticacao(TokenService tokenService) {
        this.tokenService = tokenService;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {

        String authorization = request.getHeader("Authorization");

        if (authorization == null || !authorization.startsWith("Bearer ")) {
            // A configuração de segurança decide se a rota aceita acesso anônimo.
            filterChain.doFilter(request, response);
            return;
        }

        String token = authorization.substring("Bearer ".length());

        try {
            Long usuarioId = tokenService.obterIdUsuarioAcess(token);

            var autenticacao = new UsernamePasswordAuthenticationToken(
                    usuarioId, null, List.of()
            );

            var contexto = SecurityContextHolder.createEmptyContext();
            contexto.setAuthentication(autenticacao);
            SecurityContextHolder.setContext(contexto);

        } catch (JWTVerificationException | NumberFormatException e) {
            SecurityContextHolder.clearContext();
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        filterChain.doFilter(request, response);
    }
}