package br.edu.ifsp.funxyApp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootApplication
public class ApiApplication {
    public static void main(String[] args) {
       /* BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String hashReal = encoder.encode("123456");
        System.out.println("HASH CORRETO: " + hashReal);*/
        SpringApplication.run(ApiApplication.class, args);
    }

}
