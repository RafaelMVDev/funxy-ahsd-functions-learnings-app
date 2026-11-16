---- DADO USUARIO MOCK
-- Sem início = não iniciada; só início = em andamento;

-- =========================================================
-- 2. USUÁRIA DE TESTE E CONFIGURAÇÃO
-- =========================================================

SET AUTOCOMMIT FALSE;

-- Login: lia@funxy.example
-- Senha: FunxyDemo42!
-- XP: 20 + 40 + 40 + 20 = 120 pelas quatro atividades concluídas.
-- Moedas: 46 das atividades + 25 das conquistas - 30 da loja = 41.
INSERT INTO Usuario (email, senha_hash, nome, sequencia, xp, moedas)
VALUES (

           'lia@funxy.example',
           '$2b$12$Va5njyTIULxWmVorOekPzev8ZSPYj89Ar7s7yYvF0EIi6ccVsgp7S',
           'Lia Funxy',
           3, 120, 41
       );

--- INSERIR DADOS MOCK AQUI PRA PROGRRESSO E ATIVIDADES

-- =========================================================
-- 5. CONQUISTAS: DUAS DESBLOQUEADAS, UMA AINDA NO CATÁLOGO
-- =========================================================



INSERT INTO Conquista_Usuario_Acessa (id_usuario, id_conquista, data)
SELECT id_usuario, -7151, datetime_conclusao
FROM Progresso WHERE id_progresso = -7131
UNION ALL
SELECT id_usuario, -7152, datetime_conclusao
FROM Progresso WHERE id_progresso = -7141;

-- =========================================================
-- 6. LOJA, PASSE E INVENTÁRIO
-- =========================================================

INSERT INTO Inventario (id_usuario, id_item, equipado) VALUES
                                                           (1, -7161, TRUE),
                                                           (1, -7162, FALSE);

-- Sessão antiga já revogada; o login real deve criar uma nova sessão.
/*INSERT INTO Sessoes
(id_usuario, token_hash, criado_em, expira_em, revogado_em, nome_dispositivo)
VALUES
    (1, REPEAT('a', 64), CURRENT_DATE-2, CURRENT_DATE+28,
     CURRENT_DATE-1, 'Android de teste');
*/
COMMIT;
SET AUTOCOMMIT TRUE;