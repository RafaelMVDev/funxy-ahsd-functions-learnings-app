package br.edu.ifsp.funxyApp.security;


import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;

import org.springframework.security.web.SecurityFilterChain;

// Para injeção de dependencia: Sempre q um bean precisar de um PasswordEncoder, vai passar esses
@Configuration
public class ConfigSeguranca{

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(csrf -> csrf.disable()) // Desativa CSRF já que é uma API REST
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)) // API REST não guarda sessão
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/**").permitAll() // Libera rotas de login/registro (ajuste conforme seu endpoint)
                        .requestMatchers("/h2-console/**").permitAll() // Se estiver usando o H2 Console
                        .anyRequest().authenticated() // O resto exige autenticação (via token)
                )
                // Se estiver usando H2 Database, pode precisar disso para o console carregar:
                .headers(headers -> headers.frameOptions(frame -> frame.disable()))
                .build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }
}