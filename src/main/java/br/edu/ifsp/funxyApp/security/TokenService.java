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
import java.util.UUID;

@Service
public class TokenService {

    private static final String ISSUER = "funxy-learning-app"; // q isso
    private static final Duration DURACAO_ACESS_TOKEN = Duration.ofHours(2); // token dura 2 horas até expirar
    private static final Duration DURACAO_REFRESH_TOKEN = Duration.ofHours(720); // token dura 720 horas até expirar


    private final Algorithm algoritmo;
    private final JWTVerifier verificadorAcessToken;
    private final JWTVerifier verificadorRefreshToken;


    public TokenService(@Value("${app.jwt.secret}") String segredoBase64) {
        byte[] segredo = Base64.getDecoder().decode(segredoBase64);

        if (segredo.length < 32) {
            throw new IllegalArgumentException(
                    "A chave JWT precisa ter pelo menos 32 bytes");
        }

        this.algoritmo = Algorithm.HMAC256(segredo);
        this.verificadorAcessToken = JWT.require(algoritmo)
                .withIssuer(ISSUER)
                .withClaim("token_type", "access")
                .build();

        this.verificadorRefreshToken = JWT.require(algoritmo)
                .withIssuer(ISSUER)
                .withClaim("token_type", "refresh")
                .build();
    }

    public String criarRefreshToken(Usuario usuario) {
        Instant agora = Instant.now();

        return JWT.create()
                .withIssuer(ISSUER)
                .withSubject(usuario.getId().toString())
                .withJWTId(UUID.randomUUID().toString())  // Segurança: Evitar possibilidade 2 refresh tokens iguais no banco, caso usuário logue em mais de 1 dispositivo
                .withIssuedAt(agora)
                .withExpiresAt(agora.plus(DURACAO_REFRESH_TOKEN))
                .sign(algoritmo);
    }

    public String criarAcessToken(Usuario usuario) {
        Instant agora = Instant.now();

        return JWT.create()
                .withIssuer(ISSUER)
                .withSubject(usuario.getId().toString())
                .withIssuedAt(agora)
                .withExpiresAt(agora.plus(DURACAO_ACESS_TOKEN))
                .sign(algoritmo);
    }

    public Long obterIdUsuarioRefresh(String token) {
        // Verifica assinatura, emissor e validade antes de ler o ID.
        DecodedJWT jwt = verificadorRefreshToken.verify(token);
        return Long.valueOf(jwt.getSubject());
    }

    public Long obterIdUsuarioAcess(String token) {
        // Verifica assinatura, emissor e validade antes de ler o ID.
        DecodedJWT jwt = verificadorAcessToken.verify(token);
        return Long.valueOf(jwt.getSubject());
    }
}