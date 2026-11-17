-- Gabarito: 6*ln(x+5)/ln(9)-4    |    domínio: -4<x<4
-- FUNXY: catálogo de 5 trilhas e 15 atividades práticas.
-- Executar uma única vez, com as tabelas já criadas e o catálogo vazio.
-- Não executar junto do bloco TESTEEEEE do arquivo original.
-- IDs gerados pelo banco; nenhuma tabela de usuário/progresso é alterada.
-- Não inclui leituras. numero_atividade = 1, 2, 3 por trilha.
-- media_movimentos é uma meta inicial de projeto, não uma média medida.
-- Coordenadas dos objetos são seus CENTROS. Plano assumido: x e y de -5 a 5.
-- Gabaritos nos comentários: inserir expressão e domínio em campos separados.
-- ln é convertido para log natural pelo tratar_expressao fornecido.
-- pow evita depender da conversão de ^ para **.
-- Validação geométrica em Python: 801 amostras por trecho, retângulos centrados.
-- Não equivale a teste executado na Godot.
SET AUTOCOMMIT FALSE;

-- 1. CRIAR TODAS AS TRILHAS ANTES DAS ATIVIDADES
INSERT INTO Trilha (nome_trilha, numero_trilha) VALUES ('Função afim', '1');
INSERT INTO Trilha (nome_trilha, numero_trilha) VALUES ('Função quadrática', '2');
INSERT INTO Trilha (nome_trilha, numero_trilha) VALUES ('Função modular', '3');
INSERT INTO Trilha (nome_trilha, numero_trilha) VALUES ('Função exponencial', '4');
INSERT INTO Trilha (nome_trilha, numero_trilha) VALUES ('Função logarítmica', '5');

-- 2. CRIAR AS ATIVIDADES E SEUS DADOS DE PRÁTICA

-- TRILHA 1: FUNÇÃO AFIM

-- Atividade 1: Primeira conexão (layout original)
-- Gabarito: 0.8*x-1    |    domínio: -5<x<5
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Primeira conexão', 'pratica', 40, 'Conecte o início ao fim ajustando a inclinação e a altura da reta.', 1, 10
FROM Trilha WHERE nome_trilha = 'Função afim';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -5,
    "y": -5,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 5,
    "y": 3,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": 3,
    "largura": 1,
    "altura": 1.5
  },
  {
    "tipo": "obstaculo",
    "x": -3,
    "y": -1,
    "largura": 0.8,
    "altura": 2
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função afim' AND a.numero_atividade = 1;

-- Atividade 2: Descida controlada (nova)
-- Gabarito: -0.5*x+1    |    domínio: -4<x<4
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Descida controlada', 'pratica', 60, 'Explore uma reta decrescente sem tocar nos obstáculos.', 2, 15
FROM Trilha WHERE nome_trilha = 'Função afim';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": 3,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": -1,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": -2,
    "largura": 1.5,
    "altura": 1.5
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": 3,
    "largura": 1,
    "altura": 2
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função afim' AND a.numero_atividade = 2;

-- Atividade 3: Travessia diagonal (nova)
-- Gabarito: 0.75*x    |    domínio: -4<x<4
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Travessia diagonal', 'pratica', 80, 'Encontre uma reta que passe pela origem e conecte os dois pontos.', 3, 20
FROM Trilha WHERE nome_trilha = 'Função afim';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": -3,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": 3,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": 2,
    "largura": 1.5,
    "altura": 2
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": -2,
    "largura": 1.5,
    "altura": 2
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função afim' AND a.numero_atividade = 3;

-- TRILHA 2: FUNÇÃO QUADRÁTICA

-- Atividade 1: Por baixo do bloqueio (layout original)
-- Gabarito: x*x-4    |    domínio: -3<x<3
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Por baixo do bloqueio', 'pratica', 40, 'Use uma parábola com concavidade para cima para contornar o bloqueio central.', 1, 10
FROM Trilha WHERE nome_trilha = 'Função quadrática';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -3,
    "y": 5,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 3,
    "y": 5,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": 2,
    "largura": 2,
    "altura": 4
  },
  {
    "tipo": "obstaculo",
    "x": -4,
    "y": -2,
    "largura": 1,
    "altura": 2
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função quadrática' AND a.numero_atividade = 1;

-- Atividade 2: Arco sobre o obstáculo (nova)
-- Gabarito: -x*x+4    |    domínio: -2.5<x<2.5
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Arco sobre o obstáculo', 'pratica', 60, 'Inverta a concavidade e passe por cima do obstáculo central.', 2, 15
FROM Trilha WHERE nome_trilha = 'Função quadrática';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -2.5,
    "y": -2.25,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 2.5,
    "y": -2.25,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": 0,
    "largura": 2,
    "altura": 2
  },
  {
    "tipo": "obstaculo",
    "x": -4,
    "y": 2,
    "largura": 1,
    "altura": 2
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função quadrática' AND a.numero_atividade = 2;

-- Atividade 3: Vértice deslocado (nova)
-- Gabarito: 0.5*(x+1)*(x+1)-1.5    |    domínio: -4<x<2
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Vértice deslocado', 'pratica', 80, 'Desloque o vértice da parábola para conectar pontos que não são simétricos em relação ao eixo y.', 3, 20
FROM Trilha WHERE nome_trilha = 'Função quadrática';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": 3,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 2,
    "y": 3,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -1,
    "y": 2,
    "largura": 2,
    "altura": 2
  },
  {
    "tipo": "obstaculo",
    "x": 4,
    "y": -2,
    "largura": 1,
    "altura": 2
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função quadrática' AND a.numero_atividade = 3;

-- TRILHA 3: FUNÇÃO MODULAR

-- Atividade 1: Um vale no caminho (layout original)
-- Gabarito: abs(x)-5    |    domínio: -4<x<4
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Um vale no caminho', 'pratica', 40, 'Use o valor absoluto para criar um caminho em V abaixo do bloqueio.', 1, 10
FROM Trilha WHERE nome_trilha = 'Função modular';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": -1,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": -1,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": -1,
    "largura": 3,
    "altura": 2
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": 4,
    "largura": 1.5,
    "altura": 1.5
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função modular' AND a.numero_atividade = 1;

-- Atividade 2: Pico central (nova)
-- Gabarito: -abs(x)+4    |    domínio: -4<x<4
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Pico central', 'pratica', 60, 'Reflita o gráfico modular para construir um pico acima do obstáculo.', 2, 15
FROM Trilha WHERE nome_trilha = 'Função modular';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": 0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": 0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": 0,
    "largura": 2,
    "altura": 2
  },
  {
    "tipo": "obstaculo",
    "x": -3,
    "y": 4,
    "largura": 1,
    "altura": 1
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função modular' AND a.numero_atividade = 2;

-- Atividade 3: Vale à esquerda (nova)
-- Gabarito: abs(x+1)    |    domínio: -4<x<2
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Vale à esquerda', 'pratica', 80, 'Desloque o vértice do gráfico modular para a esquerda.', 3, 20
FROM Trilha WHERE nome_trilha = 'Função modular';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": 3,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 2,
    "y": 3,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -1,
    "y": 3,
    "largura": 2,
    "altura": 2
  },
  {
    "tipo": "obstaculo",
    "x": 3,
    "y": -2,
    "largura": 1,
    "altura": 2
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função modular' AND a.numero_atividade = 3;

-- TRILHA 4: FUNÇÃO EXPONENCIAL

-- Atividade 1: Contorno por trechos (layout original)
-- Gabarito: -3.5+5.5*(pow(2,x+4)-1)/(pow(2,2.8)-1)    |    domínio: -4<x<-1.2
-- Gabarito: 2+0.5*(pow(2,x+1.2)-1)/(pow(2,2.4)-1)    |    domínio: -1.2<x<1.2
-- Gabarito: 2.5+1.5*(pow(2,x-1.2)-1)/(pow(2,1.8)-1)    |    domínio: 1.2<x<3
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Contorno por trechos', 'pratica', 40, 'Conecte trechos exponenciais usando domínios para passar acima dos obstáculos.', 1, 10
FROM Trilha WHERE nome_trilha = 'Função exponencial';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 3, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": -3.5,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 3,
    "y": 4,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": 0,
    "largura": 2,
    "altura": 3
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": -2,
    "largura": 1.5,
    "altura": 2
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função exponencial' AND a.numero_atividade = 1;

-- Atividade 2: Crescimento deslocado (nova)
-- Gabarito: pow(2,x)-3    |    domínio: -3<x<2
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Crescimento deslocado', 'pratica', 60, 'Desloque uma exponencial crescente para baixo.', 2, 15
FROM Trilha WHERE nome_trilha = 'Função exponencial';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -3,
    "y": -2.875,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 2,
    "y": 1,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": 1,
    "largura": 1,
    "altura": 1
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": 0,
    "largura": 1,
    "altura": 1.5
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função exponencial' AND a.numero_atividade = 2;

-- Atividade 3: Decaimento (nova)
-- Gabarito: pow(2,-x)-1    |    domínio: -2<x<3
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Decaimento', 'pratica', 80, 'Explore uma exponencial decrescente e seu deslocamento vertical.', 3, 20
FROM Trilha WHERE nome_trilha = 'Função exponencial';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -2,
    "y": 3,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 3,
    "y": -0.875,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": 2,
    "largura": 1,
    "altura": 1
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": -3,
    "largura": 1.5,
    "altura": 1
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função exponencial' AND a.numero_atividade = 3;

-- TRILHA 5: FUNÇÃO LOGARÍTMICA

-- Atividade 1: Primeiro logaritmo (layout original)
-- Gabarito: 6*ln(x+5)/ln(9)-4    |    domínio: -4<x<4
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Primeiro logaritmo', 'pratica', 40, 'Desloque o domínio do logaritmo para conectar os pontos sem cruzar os obstáculos.', 1, 10
FROM Trilha WHERE nome_trilha = 'Função logarítmica';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": -4,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": 2,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": -0.5,
    "largura": 1.5,
    "altura": 2
  },
  {
    "tipo": "obstaculo",
    "x": 0.5,
    "y": 3,
    "largura": 1,
    "altura": 2
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função logarítmica' AND a.numero_atividade = 1;

-- Atividade 2: Crescimento suave (nova)
-- Gabarito: 2*ln(x+4)-3    |    domínio: -3<x<4
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Crescimento suave', 'pratica', 60, 'Ajuste a escala vertical e o deslocamento de uma função logarítmica.', 2, 15
FROM Trilha WHERE nome_trilha = 'Função logarítmica';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -3,
    "y": -3,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": 1.1588830833596715,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -1,
    "y": 3,
    "largura": 1.5,
    "altura": 1.5
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": -2,
    "largura": 1.5,
    "altura": 1.5
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função logarítmica' AND a.numero_atividade = 2;

-- Atividade 3: Logaritmo refletido (nova)
-- Gabarito: 2-2*ln(x+5)    |    domínio: -4<x<3
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Logaritmo refletido', 'pratica', 80, 'Reflita o logaritmo para criar um caminho decrescente.', 3, 20
FROM Trilha WHERE nome_trilha = 'Função logarítmica';

INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": 2,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 3,
    "y": -2.1588830833596715,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": 2,
    "largura": 1.5,
    "altura": 1
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": -3.5,
    "largura": 1,
    "altura": 1
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função logarítmica' AND a.numero_atividade = 3;

COMMIT;
SET AUTOCOMMIT TRUE;

-- Conferência: 15 linhas, 3 por trilha.
SELECT t.id_trilha, t.nome_trilha, a.id_atividade, a.numero_atividade,
       a.titulo, p.media_movimentos, p.colisoes_malha
FROM Trilha t
         JOIN Atividades a ON a.id_trilha = t.id_trilha
         JOIN Atividades_Pratica p ON p.id_atividade = a.id_atividade
ORDER BY t.numero_trilha, a.numero_atividade;


-- =====================================================
-- CRIA UMA LEITURA POR TRILHA, CASO AINDA NÃO EXISTA
-- =====================================================

INSERT INTO Atividades (
    id_trilha,
    numero_atividade,
    titulo,
    descricao,
    tipo,
    xp_base,
    moeda_base
)
SELECT
    t.id_trilha,
    0,
    'Introdução',
    'Conceitos iniciais da trilha.',
    'leitura',
    0,
    0
FROM Trilha t
WHERE t.id_trilha IN (1, 2, 3, 4, 5)
  AND NOT EXISTS (
    SELECT 1
    FROM Atividades a
    WHERE a.id_trilha = t.id_trilha
      AND a.tipo = 'leitura'
);

-- Cria os registros da especialização usando os IDs gerados.
INSERT INTO Atividades_Leitura (
    id_atividade,
    textos,
    imagens
)
SELECT
    a.id_atividade,
    '[]',
    '[]'
FROM Atividades a
WHERE a.tipo = 'leitura'
  AND a.id_trilha IN (1, 2, 3, 4, 5)
  AND NOT EXISTS (
    SELECT 1
    FROM Atividades_Leitura leitura
    WHERE leitura.id_atividade = a.id_atividade
);


-- =====================================================
-- TRILHA 1 — INTRODUÇÃO ÀS FUNÇÕES
-- =====================================================

UPDATE Atividades
SET numero_atividade = 0,
    titulo = 'O que é uma função?',
    descricao = 'Entenda entradas, saídas e pontos no plano cartesiano.'
WHERE id_trilha = 1 AND tipo = 'leitura';

UPDATE Atividades_Leitura
SET textos = '[
    "Uma função relaciona valores de entrada a valores de saída. Cada entrada permitida deve produzir uma única saída.",
    "Chamamos a entrada de x e podemos escrever a saída como f(x). Na função f(x) = x + 2, a regra é somar 2 ao valor escolhido.",
    "Se x = 1, então f(1) = 3. Se x = 4, então f(4) = 6. A regra é a mesma, mas a saída depende da entrada.",
    "Podemos representar cada resultado no plano cartesiano. O ponto (1, 3) indica entrada 1 e saída 3.",
    "O eixo horizontal representa x e o eixo vertical representa y. Para localizar (1, 3), avance 1 unidade à direita e 3 unidades para cima a partir da origem.",
    "Nos desafios do Funxy, você vai escrever funções e observar seus gráficos. Comece testando valores simples e acompanhando os pontos."
]'
WHERE id_atividade IN (
    SELECT id_atividade FROM Atividades
    WHERE id_trilha = 1 AND tipo = 'leitura'
);


-- =====================================================
-- TRILHA 2 — FUNÇÃO AFIM
-- =====================================================

UPDATE Atividades
SET numero_atividade = 0,
    titulo = 'Construindo caminhos com retas',
    descricao = 'Descubra como os coeficientes mudam o gráfico de uma função afim.'
WHERE id_trilha = 2 AND tipo = 'leitura';

UPDATE Atividades_Leitura
SET textos = '[
    "A função afim tem a forma f(x) = a*x + b. Seu gráfico é uma reta.",
    "O coeficiente a determina a inclinação. Quando a é positivo, a reta sobe da esquerda para a direita. Quando a é negativo, ela desce.",
    "Na função f(x) = 2*x + 1, aumentar x em 1 faz a saída aumentar em 2. A reta passa pelos pontos (0, 1), (1, 3) e (2, 5).",
    "O coeficiente b indica onde a reta cruza o eixo vertical. Em f(x) = x + 3, esse ponto é (0, 3).",
    "Se a = 0, a função é constante: f(x) = b. Seu gráfico é uma reta horizontal, pois a saída não muda.",
    "Para encontrar onde f(x) = 2*x - 4 cruza o eixo horizontal, resolva 2*x - 4 = 0. O resultado é x = 2, formando o ponto (2, 0).",
    "No Funxy, ajuste a para mudar a inclinação do caminho e b para deslocar a reta para cima ou para baixo."
]'
WHERE id_atividade IN (
    SELECT id_atividade FROM Atividades
    WHERE id_trilha = 2 AND tipo = 'leitura'
);


-- =====================================================
-- TRILHA 3 — DOMÍNIOS E INTERVALOS
-- =====================================================

UPDATE Atividades
SET numero_atividade = 0,
    titulo = 'Escolhendo onde o caminho existe',
    descricao = 'Use intervalos para limitar os trechos dos gráficos.'
WHERE id_trilha = 3 AND tipo = 'leitura';

UPDATE Atividades_Leitura
SET textos = '[
    "O domínio é o conjunto de valores de x permitidos em uma função. Restringir o domínio permite mostrar apenas uma parte do gráfico.",
    "A condição 5 > x > -5 permite valores maiores que -5 e menores que 5. Os extremos -5 e 5 não pertencem ao intervalo.",
    "A condição 5 >= x >= -5 inclui os extremos. Nesse caso, x pode ser exatamente -5 ou exatamente 5.",
    "Também podemos misturar os operadores. Em 3 >= x > -2, o valor 3 está incluído e o valor -2 está excluído.",
    "Imagine a função f(x) = x + 1 restrita a 2 >= x >= -1. O trecho vai do ponto (-1, 0) até o ponto (2, 3), incluindo os dois.",
    "Algumas expressões já possuem restrições próprias. Em f(x) = 1/x, por exemplo, x não pode ser zero, porque a divisão por zero não está definida.",
    "Nos desafios, combine a expressão da função com um intervalo para controlar onde cada trecho começa e termina."
]'
WHERE id_atividade IN (
    SELECT id_atividade FROM Atividades
    WHERE id_trilha = 3 AND tipo = 'leitura'
);


-- =====================================================
-- TRILHA 4 — FUNÇÃO QUADRÁTICA
-- =====================================================

UPDATE Atividades
SET numero_atividade = 0,
    titulo = 'Explorando parábolas',
    descricao = 'Aprenda a reconhecer e posicionar curvas quadráticas.'
WHERE id_trilha = 4 AND tipo = 'leitura';

UPDATE Atividades_Leitura
SET textos = '[
    "Uma função quadrática tem a forma f(x) = a*x² + b*x + c, com a diferente de zero. Seu gráfico é uma parábola.",
    "Se a é positivo, a concavidade fica voltada para cima. Se a é negativo, fica voltada para baixo.",
    "Na função f(x) = x², alguns pontos são (-2, 4), (-1, 1), (0, 0), (1, 1) e (2, 4). Observe a simetria em relação ao eixo vertical.",
    "O vértice é o ponto de mínimo quando a parábola abre para cima, ou de máximo quando abre para baixo. Em f(x) = x², ele está em (0, 0).",
    "Na forma f(x) = a*(x - h)² + k, o vértice fica em (h, k). Por exemplo, f(x) = (x - 2)² + 1 tem vértice em (2, 1).",
    "Para descobrir onde f(x) = x² - 4 cruza o eixo horizontal, resolva x² - 4 = 0. As raízes são x = -2 e x = 2.",
    "No Funxy, experimente posicionar o vértice e restringir o domínio para usar apenas o trecho da parábola que ajuda a alcançar o objetivo."
]'
WHERE id_atividade IN (
    SELECT id_atividade FROM Atividades
    WHERE id_trilha = 4 AND tipo = 'leitura'
);


-- =====================================================
-- TRILHA 5 — FUNÇÃO MODULAR E CAMINHOS POR TRECHOS
-- =====================================================

UPDATE Atividades
SET numero_atividade = 0,
    titulo = 'Combinando caminhos',
    descricao = 'Explore o módulo e combine funções em diferentes intervalos.'
WHERE id_trilha = 5 AND tipo = 'leitura';

UPDATE Atividades_Leitura
SET textos = '[
    "O módulo de um número representa sua distância até zero. Por isso, |3| = 3 e |-3| = 3.",
    "A função f(x) = |x| tem um gráfico em forma de V. Para x negativo, a saída é -x. Para x positivo ou zero, a saída é x.",
    "Na função f(x) = |x - 2| + 1, o ponto mais baixo fica em (2, 1). Subtrair 2 dentro do módulo desloca o gráfico para a direita.",
    "Também podemos construir caminhos com funções diferentes em intervalos diferentes. Cada expressão controla um trecho.",
    "Por exemplo, use f(x) = x + 2 no intervalo 0 >= x >= -2 e g(x) = -x + 2 no intervalo 2 >= x > 0.",
    "O primeiro trecho chega ao ponto (0, 2). O segundo se aproxima desse mesmo ponto quando x se aproxima de zero pela direita, formando um caminho conectado.",
    "Ao combinar trechos, confira os valores nas junções. Se uma expressão termina em uma altura e a próxima começa em outra, haverá um salto.",
    "Agora combine o que aprendeu: escolha as funções, ajuste suas posições e defina os domínios para construir o caminho da fase."
]'
WHERE id_atividade IN (
    SELECT id_atividade FROM Atividades
    WHERE id_trilha = 5 AND tipo = 'leitura'
);