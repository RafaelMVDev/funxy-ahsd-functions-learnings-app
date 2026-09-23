package br.edu.ifsp.funxyApp.security;

import br.edu.ifsp.funxyApp.model.Usuario;
import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.Instant;
import java.util.Base64;

@Service
public class TokenService {

    private static final String ISSUER = "funxy-learning-app";
    private static final Duration DURACAO = Duration.ofHours(2);

    private final Algorithm algoritmo;
    private final JWTVerifier verificador;

    public TokenService(@Value("${app.jwt.secret}") String segredoBase64) {
        byte[] segredo = Base64.getDecoder().decode(segredoBase64);

        if (segredo.length < 32) {
            throw new IllegalArgumentException(
                    "A chave JWT precisa ter pelo menos 32 bytes");
        }

        this.algoritmo = Algorithm.HMAC256(segredo);
        this.verificador = JWT.require(algoritmo)
                .withIssuer(ISSUER)
                .build();
    }

    public String criarToken(Usuario usuario) {
        Instant agora = Instant.now();

        return JWT.create()
                .withIssuer(ISSUER)
                .withSubject(usuario.getId().toString())
                .withIssuedAt(agora)
                .withExpiresAt(agora.plus(DURACAO))
                .sign(algoritmo);
    }

    public Long obterIdUsuario(String token) {
        // Verifica assinatura, emissor e validade antes de ler o ID.
        DecodedJWT jwt = verificador.verify(token);
        return Long.valueOf(jwt.getSubject());
    }
}