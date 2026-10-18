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


@Configuration
public class ConfigSeguranca{
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception { // tirando CSRF e setanto estado da sessão para stateless
        return http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll() // Libera TUDO temporariamente para testes
                )
                .headers(headers -> headers.frameOptions(frame -> frame.disable()))
                .build();
    }
    /*
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/login", "/auth/**").permitAll() // Libera explicitamente as rotas de auth
                        .requestMatchers("/h2-console/**").permitAll()
                        .anyRequest().authenticated()
                )
                .headers(headers -> headers.frameOptions(frame -> frame.disable()))
                .build();
    } */

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    } // Necessário para Injeção de dependência do Spring

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }
}