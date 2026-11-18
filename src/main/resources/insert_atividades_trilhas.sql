/*

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

"""

 */

-- FUNXY: 15 fases desafiadoras, 5 trilhas, 1 leitura por trilha.
-- H2: substituir o antigo arquivo de inserts. Executar sobre catálogo VAZIO.
-- Não misturar com os inserts antigos. Não altera usuário, inventário ou progresso.
-- x/y = CENTRO; largura/altura = tamanho TOTAL em unidades cartesianas.
-- Plano do projeto: 300 x 300 px, [-5,5] em ambos os eixos, 30 px/unidade.
-- Paredes: bordas x +/- largura/2, y +/- altura/2; Y é invertido na tela.
-- Gabaritos e validação ficam em arquivos separados, não no payload da API.
-- media_movimentos = quantidade de trechos do gabarito, não média medida.
SET AUTOCOMMIT FALSE;

INSERT INTO Trilha (nome_trilha, numero_trilha) VALUES ('Função afim', '1');
INSERT INTO Trilha (nome_trilha, numero_trilha) VALUES ('Função quadrática', '2');
INSERT INTO Trilha (nome_trilha, numero_trilha) VALUES ('Função modular', '3');
INSERT INTO Trilha (nome_trilha, numero_trilha) VALUES ('Função exponencial', '4');
INSERT INTO Trilha (nome_trilha, numero_trilha) VALUES ('Função logarítmica', '5');

-- Função afim / fase 1: Alinhamento preciso
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Alinhamento preciso', 'pratica', 40, 'Ajuste inclinação e intercepto para atravessar cinco passagens.', 1, 10
FROM Trilha WHERE nome_trilha = 'Função afim';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": -3.5,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": 2.5,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -3,
    "y": -4.155,
    "largura": 0.5,
    "altura": 1.69
  },
  {
    "tipo": "obstaculo",
    "x": -3,
    "y": 1.405,
    "largura": 0.5,
    "altura": 7.19
  },
  {
    "tipo": "obstaculo",
    "x": -1.5,
    "y": -3.5925,
    "largura": 0.5,
    "altura": 2.815
  },
  {
    "tipo": "obstaculo",
    "x": -1.5,
    "y": 1.9675,
    "largura": 0.5,
    "altura": 6.065
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": -3.03,
    "largura": 0.5,
    "altura": 3.94
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": 2.53,
    "largura": 0.5,
    "altura": 4.94
  },
  {
    "tipo": "obstaculo",
    "x": 1.5,
    "y": -2.4675,
    "largura": 0.5,
    "altura": 5.065
  },
  {
    "tipo": "obstaculo",
    "x": 1.5,
    "y": 3.0925,
    "largura": 0.5,
    "altura": 3.815
  },
  {
    "tipo": "obstaculo",
    "x": 3,
    "y": -1.905,
    "largura": 0.5,
    "altura": 6.19
  },
  {
    "tipo": "obstaculo",
    "x": 3,
    "y": 3.655,
    "largura": 0.5,
    "altura": 2.69
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função afim' AND a.numero_atividade = 1 AND a.tipo = 'pratica';

-- Função afim / fase 2: Mudança de direção
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Mudança de direção', 'pratica', 60, 'Conecte dois trechos afins com inclinações diferentes e escolha os domínios.', 2, 15
FROM Trilha WHERE nome_trilha = 'Função afim';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 2, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": -3.5,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": -2.9,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -3,
    "y": -3.997,
    "largura": 0.55,
    "altura": 2.006
  },
  {
    "tipo": "obstaculo",
    "x": -3,
    "y": 1.697,
    "largura": 0.55,
    "altura": 6.606
  },
  {
    "tipo": "obstaculo",
    "x": -1.8,
    "y": -3.277,
    "largura": 0.55,
    "altura": 3.446
  },
  {
    "tipo": "obstaculo",
    "x": -1.8,
    "y": 2.417,
    "largura": 0.55,
    "altura": 5.166
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": -2.497,
    "largura": 0.55,
    "altura": 5.006
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": 2.99,
    "largura": 0.55,
    "altura": 4.02
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": -3.028,
    "largura": 0.55,
    "altura": 3.944
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": 2.528,
    "largura": 0.55,
    "altura": 4.944
  },
  {
    "tipo": "obstaculo",
    "x": 2.5,
    "y": -3.628,
    "largura": 0.55,
    "altura": 2.744
  },
  {
    "tipo": "obstaculo",
    "x": 2.5,
    "y": 1.928,
    "largura": 0.55,
    "altura": 6.144
  },
  {
    "tipo": "obstaculo",
    "x": 3.4,
    "y": -3.988,
    "largura": 0.55,
    "altura": 2.024
  },
  {
    "tipo": "obstaculo",
    "x": 3.4,
    "y": 1.568,
    "largura": 0.55,
    "altura": 6.864
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função afim' AND a.numero_atividade = 2 AND a.tipo = 'pratica';

-- Função afim / fase 3: Zigue-zague controlado
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Zigue-zague controlado', 'pratica', 80, 'Planeje três retas conectadas sem prolongá-las para dentro das paredes.', 3, 20
FROM Trilha WHERE nome_trilha = 'Função afim';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 3, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": 2.5,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": -0.6,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -3.2,
    "y": -1.955,
    "largura": 0.6,
    "altura": 6.09
  },
  {
    "tipo": "obstaculo",
    "x": -3.2,
    "y": 3.655,
    "largura": 0.6,
    "altura": 2.69
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": -2.555,
    "largura": 0.6,
    "altura": 4.89
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": 3.055,
    "largura": 0.6,
    "altura": 3.89
  },
  {
    "tipo": "obstaculo",
    "x": -0.6,
    "y": -2.408,
    "largura": 0.6,
    "altura": 5.184
  },
  {
    "tipo": "obstaculo",
    "x": -0.6,
    "y": 3.128,
    "largura": 0.6,
    "altura": 3.744
  },
  {
    "tipo": "obstaculo",
    "x": 0.6,
    "y": -1.928,
    "largura": 0.6,
    "altura": 6.144
  },
  {
    "tipo": "obstaculo",
    "x": 0.6,
    "y": 3.608,
    "largura": 0.6,
    "altura": 2.784
  },
  {
    "tipo": "obstaculo",
    "x": 2.2,
    "y": -2.062,
    "largura": 0.6,
    "altura": 5.876
  },
  {
    "tipo": "obstaculo",
    "x": 2.2,
    "y": 3.622,
    "largura": 0.6,
    "altura": 2.756
  },
  {
    "tipo": "obstaculo",
    "x": 3.3,
    "y": -2.722,
    "largura": 0.6,
    "altura": 4.556
  },
  {
    "tipo": "obstaculo",
    "x": 3.3,
    "y": 2.962,
    "largura": 0.6,
    "altura": 4.076
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função afim' AND a.numero_atividade = 3 AND a.tipo = 'pratica';

-- Função quadrática / fase 1: Vale deslocado
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Vale deslocado', 'pratica', 40, 'Posicione o vértice à esquerda e ajuste a abertura da parábola.', 1, 10
FROM Trilha WHERE nome_trilha = 'Função quadrática';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": 1.9,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 3,
    "y": 1.9,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -3,
    "y": -3.20952,
    "largura": 0.5,
    "altura": 3.58096
  },
  {
    "tipo": "obstaculo",
    "x": -3,
    "y": 2.75048,
    "largura": 0.5,
    "altura": 4.49904
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": -3.88152,
    "largura": 0.5,
    "altura": 2.23696
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": 1.82248,
    "largura": 0.5,
    "altura": 6.35504
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": -4.16,
    "largura": 0.5,
    "altura": 1.68
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": 1.18048,
    "largura": 0.5,
    "altura": 7.63904
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": -3.88152,
    "largura": 0.5,
    "altura": 2.23696
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": 1.82248,
    "largura": 0.5,
    "altura": 6.35504
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": -3.20952,
    "largura": 0.5,
    "altura": 3.58096
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": 2.75048,
    "largura": 0.5,
    "altura": 4.49904
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função quadrática' AND a.numero_atividade = 1 AND a.tipo = 'pratica';

-- Função quadrática / fase 2: Teto curvo
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Teto curvo', 'pratica', 60, 'Use concavidade negativa e um vértice deslocado para atravessar as passagens.', 2, 15
FROM Trilha WHERE nome_trilha = 'Função quadrática';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -2,
    "y": -1.0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": -1.0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -1.3,
    "y": -2.63901,
    "largura": 0.55,
    "altura": 4.72199
  },
  {
    "tipo": "obstaculo",
    "x": -1.3,
    "y": 3.43449,
    "largura": 0.55,
    "altura": 3.13101
  },
  {
    "tipo": "obstaculo",
    "x": -0.2,
    "y": -1.48676,
    "largura": 0.55,
    "altura": 7.02649
  },
  {
    "tipo": "obstaculo",
    "x": -0.2,
    "y": 4.20724,
    "largura": 0.55,
    "altura": 1.58551
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": -0.91976,
    "largura": 0.55,
    "altura": 8.16049
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": 4.39,
    "largura": 0.55,
    "altura": 1.22
  },
  {
    "tipo": "obstaculo",
    "x": 2.2,
    "y": -1.48676,
    "largura": 0.55,
    "altura": 7.02649
  },
  {
    "tipo": "obstaculo",
    "x": 2.2,
    "y": 4.20724,
    "largura": 0.55,
    "altura": 1.58551
  },
  {
    "tipo": "obstaculo",
    "x": 3.3,
    "y": -2.63901,
    "largura": 0.55,
    "altura": 4.72199
  },
  {
    "tipo": "obstaculo",
    "x": 3.3,
    "y": 3.43449,
    "largura": 0.55,
    "altura": 3.13101
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função quadrática' AND a.numero_atividade = 2 AND a.tipo = 'pratica';

-- Função quadrática / fase 3: Parábola assimétrica
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Parábola assimétrica', 'pratica', 80, 'Encontre uma quadrática com eixo deslocado; os alvos estão em alturas diferentes.', 3, 20
FROM Trilha WHERE nome_trilha = 'Função quadrática';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": 1.8,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 3,
    "y": 1.1,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -3.2,
    "y": -2.80166,
    "largura": 0.6,
    "altura": 4.39667
  },
  {
    "tipo": "obstaculo",
    "x": -3.2,
    "y": 3.07473,
    "largura": 0.6,
    "altura": 3.85053
  },
  {
    "tipo": "obstaculo",
    "x": -2.1,
    "y": -3.44407,
    "largura": 0.6,
    "altura": 3.11187
  },
  {
    "tipo": "obstaculo",
    "x": -2.1,
    "y": 2.18813,
    "largura": 0.6,
    "altura": 5.62373
  },
  {
    "tipo": "obstaculo",
    "x": -0.8,
    "y": -3.73527,
    "largura": 0.6,
    "altura": 2.52947
  },
  {
    "tipo": "obstaculo",
    "x": -0.8,
    "y": 1.60833,
    "largura": 0.6,
    "altura": 6.78333
  },
  {
    "tipo": "obstaculo",
    "x": 0.4,
    "y": -3.71686,
    "largura": 0.6,
    "altura": 2.56627
  },
  {
    "tipo": "obstaculo",
    "x": 0.4,
    "y": 1.68594,
    "largura": 0.6,
    "altura": 6.62813
  },
  {
    "tipo": "obstaculo",
    "x": 1.6,
    "y": -3.37007,
    "largura": 0.6,
    "altura": 3.25987
  },
  {
    "tipo": "obstaculo",
    "x": 1.6,
    "y": 2.29914,
    "largura": 0.6,
    "altura": 5.40173
  },
  {
    "tipo": "obstaculo",
    "x": 2.5,
    "y": -2.78914,
    "largura": 0.5,
    "altura": 4.42172
  },
  {
    "tipo": "obstaculo",
    "x": 2.5,
    "y": 2.99486,
    "largura": 0.5,
    "altura": 4.01028
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função quadrática' AND a.numero_atividade = 3 AND a.tipo = 'pratica';

-- Função modular / fase 1: V fora do centro
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'V fora do centro', 'pratica', 40, 'Desloque o vértice do módulo e ajuste a inclinação dos dois braços.', 1, 10
FROM Trilha WHERE nome_trilha = 'Função modular';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": 0.35,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 3,
    "y": 0.35,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -3,
    "y": -3.211,
    "largura": 0.5,
    "altura": 3.578
  },
  {
    "tipo": "obstaculo",
    "x": -3,
    "y": 2.461,
    "largura": 0.5,
    "altura": 5.078
  },
  {
    "tipo": "obstaculo",
    "x": -1.7,
    "y": -3.926,
    "largura": 0.5,
    "altura": 2.148
  },
  {
    "tipo": "obstaculo",
    "x": -1.7,
    "y": 1.746,
    "largura": 0.5,
    "altura": 6.508
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": -4.41,
    "largura": 0.5,
    "altura": 1.18
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": 1.086,
    "largura": 0.5,
    "altura": 7.828
  },
  {
    "tipo": "obstaculo",
    "x": 0.7,
    "y": -3.926,
    "largura": 0.5,
    "altura": 2.148
  },
  {
    "tipo": "obstaculo",
    "x": 0.7,
    "y": 1.746,
    "largura": 0.5,
    "altura": 6.508
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": -3.211,
    "largura": 0.5,
    "altura": 3.578
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": 2.461,
    "largura": 0.5,
    "altura": 5.078
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função modular' AND a.numero_atividade = 1 AND a.tipo = 'pratica';

-- Função modular / fase 2: Pico estreito
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Pico estreito', 'pratica', 60, 'Reflita e desloque a função modular para atravessar o pico sem tocar no teto.', 2, 15
FROM Trilha WHERE nome_trilha = 'Função modular';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -3,
    "y": 0.0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": 0.9,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": -2.34525,
    "largura": 0.55,
    "altura": 5.3095
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": 3.24525,
    "largura": 0.55,
    "altura": 3.5095
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": -1.67025,
    "largura": 0.55,
    "altura": 6.6595
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": 3.92025,
    "largura": 0.55,
    "altura": 2.1595
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": -0.99525,
    "largura": 0.55,
    "altura": 8.0095
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": 4.44,
    "largura": 0.55,
    "altura": 1.12
  },
  {
    "tipo": "obstaculo",
    "x": 2.2,
    "y": -1.53525,
    "largura": 0.55,
    "altura": 6.9295
  },
  {
    "tipo": "obstaculo",
    "x": 2.2,
    "y": 4.05525,
    "largura": 0.55,
    "altura": 1.8895
  },
  {
    "tipo": "obstaculo",
    "x": 3.3,
    "y": -2.03025,
    "largura": 0.55,
    "altura": 5.9395
  },
  {
    "tipo": "obstaculo",
    "x": 3.3,
    "y": 3.56025,
    "largura": 0.55,
    "altura": 2.8795
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função modular' AND a.numero_atividade = 2 AND a.tipo = 'pratica';

-- Função modular / fase 3: Dois vales
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Dois vales', 'pratica', 80, 'Use dois trechos modulares conectados e ajuste seus domínios em cada vale.', 3, 20
FROM Trilha WHERE nome_trilha = 'Função modular';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 2, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": 0.0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": 0.0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -3.2,
    "y": -3.322,
    "largura": 0.6,
    "altura": 3.356
  },
  {
    "tipo": "obstaculo",
    "x": -3.2,
    "y": 2.362,
    "largura": 0.6,
    "altura": 5.276
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": -3.82,
    "largura": 0.6,
    "altura": 2.36
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": 1.642,
    "largura": 0.6,
    "altura": 6.716
  },
  {
    "tipo": "obstaculo",
    "x": -0.8,
    "y": -3.31,
    "largura": 0.56,
    "altura": 3.38
  },
  {
    "tipo": "obstaculo",
    "x": -0.8,
    "y": 2.35,
    "largura": 0.56,
    "altura": 5.3
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": -2.9,
    "largura": 0.56,
    "altura": 4.2
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": 2.62,
    "largura": 0.56,
    "altura": 4.76
  },
  {
    "tipo": "obstaculo",
    "x": 0.8,
    "y": -3.54,
    "largura": 0.56,
    "altura": 2.92
  },
  {
    "tipo": "obstaculo",
    "x": 0.8,
    "y": 2.26,
    "largura": 0.56,
    "altura": 5.48
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": -4.22,
    "largura": 0.6,
    "altura": 1.56
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": 1.316,
    "largura": 0.6,
    "altura": 7.368
  },
  {
    "tipo": "obstaculo",
    "x": 3.2,
    "y": -3.556,
    "largura": 0.6,
    "altura": 2.888
  },
  {
    "tipo": "obstaculo",
    "x": 3.2,
    "y": 2.276,
    "largura": 0.6,
    "altura": 5.448
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função modular' AND a.numero_atividade = 3 AND a.tipo = 'pratica';

-- Função exponencial / fase 1: Arranque exponencial
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Arranque exponencial', 'pratica', 40, 'A travessia começa quase horizontal e termina com crescimento acelerado.', 1, 10
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
    "x": 2.5,
    "y": 2.65685,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -2.2,
    "y": -4.07283,
    "largura": 0.5,
    "altura": 1.85434
  },
  {
    "tipo": "obstaculo",
    "x": -2.2,
    "y": 1.29584,
    "largura": 0.5,
    "altura": 7.40832
  },
  {
    "tipo": "obstaculo",
    "x": -1.2,
    "y": -3.98566,
    "largura": 0.5,
    "altura": 2.02869
  },
  {
    "tipo": "obstaculo",
    "x": -1.2,
    "y": 1.43168,
    "largura": 0.5,
    "altura": 7.13663
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": -3.75947,
    "largura": 0.5,
    "altura": 2.48107
  },
  {
    "tipo": "obstaculo",
    "x": 0,
    "y": 1.78417,
    "largura": 0.5,
    "altura": 6.43167
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": -3.35893,
    "largura": 0.5,
    "altura": 3.28214
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": 2.40833,
    "largura": 0.5,
    "altura": 5.18334
  },
  {
    "tipo": "obstaculo",
    "x": 1.9,
    "y": -2.66515,
    "largura": 0.5,
    "altura": 4.6697
  },
  {
    "tipo": "obstaculo",
    "x": 1.9,
    "y": 3.48947,
    "largura": 0.5,
    "altura": 3.02107
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função exponencial' AND a.numero_atividade = 1 AND a.tipo = 'pratica';

-- Função exponencial / fase 2: Crescer desacelerando
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Crescer desacelerando', 'pratica', 60, 'Combine reflexão horizontal e vertical de uma exponencial para alcançar o alvo.', 2, 15
FROM Trilha WHERE nome_trilha = 'Função exponencial';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -2,
    "y": 0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 3,
    "y": 3.875,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -1.4,
    "y": -2.31597,
    "largura": 0.55,
    "altura": 5.36805
  },
  {
    "tipo": "obstaculo",
    "x": -1.4,
    "y": 3.60114,
    "largura": 0.55,
    "altura": 2.79772
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": -1.53813,
    "largura": 0.55,
    "altura": 6.92374
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": 4.08329,
    "largura": 0.55,
    "altura": 1.83342
  },
  {
    "tipo": "obstaculo",
    "x": 0.5,
    "y": -1.08907,
    "largura": 0.55,
    "altura": 7.82187
  },
  {
    "tipo": "obstaculo",
    "x": 0.5,
    "y": 4.36164,
    "largura": 0.55,
    "altura": 1.27671
  },
  {
    "tipo": "obstaculo",
    "x": 1.5,
    "y": -0.86453,
    "largura": 0.55,
    "altura": 8.27093
  },
  {
    "tipo": "obstaculo",
    "x": 1.5,
    "y": 4.50082,
    "largura": 0.55,
    "altura": 0.99836
  },
  {
    "tipo": "obstaculo",
    "x": 2.4,
    "y": -0.76032,
    "largura": 0.55,
    "altura": 8.47935
  },
  {
    "tipo": "obstaculo",
    "x": 2.4,
    "y": 4.56542,
    "largura": 0.55,
    "altura": 0.86917
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função exponencial' AND a.numero_atividade = 2 AND a.tipo = 'pratica';

-- Função exponencial / fase 3: Escala e translação
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Escala e translação', 'pratica', 80, 'Ajuste escala, deslocamento e domínio de uma exponencial em passagens mais precisas.', 3, 20
FROM Trilha WHERE nome_trilha = 'Função exponencial';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -3,
    "y": -3.3125,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 2,
    "y": 2.5,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -2.3,
    "y": -4.25215,
    "largura": 0.6,
    "altura": 1.49569
  },
  {
    "tipo": "obstaculo",
    "x": -2.3,
    "y": 1.06682,
    "largura": 0.6,
    "altura": 7.86636
  },
  {
    "tipo": "obstaculo",
    "x": -1.3,
    "y": -4.13431,
    "largura": 0.6,
    "altura": 1.73138
  },
  {
    "tipo": "obstaculo",
    "x": -1.3,
    "y": 1.26364,
    "largura": 0.6,
    "altura": 7.47271
  },
  {
    "tipo": "obstaculo",
    "x": -0.3,
    "y": -3.89204,
    "largura": 0.56,
    "altura": 2.21592
  },
  {
    "tipo": "obstaculo",
    "x": -0.3,
    "y": 1.64645,
    "largura": 0.56,
    "altura": 6.7071
  },
  {
    "tipo": "obstaculo",
    "x": 0.5,
    "y": -3.51739,
    "largura": 0.49,
    "altura": 2.96523
  },
  {
    "tipo": "obstaculo",
    "x": 0.5,
    "y": 2.18947,
    "largura": 0.49,
    "altura": 5.62105
  },
  {
    "tipo": "obstaculo",
    "x": 1.2,
    "y": -2.88036,
    "largura": 0.28,
    "altura": 4.23928
  },
  {
    "tipo": "obstaculo",
    "x": 1.2,
    "y": 2.86303,
    "largura": 0.28,
    "altura": 4.27394
  },
  {
    "tipo": "obstaculo",
    "x": 1.6,
    "y": -2.40441,
    "largura": 0.28,
    "altura": 5.19118
  },
  {
    "tipo": "obstaculo",
    "x": 1.6,
    "y": 3.49982,
    "largura": 0.28,
    "altura": 3.00037
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função exponencial' AND a.numero_atividade = 3 AND a.tipo = 'pratica';

-- Função logarítmica / fase 1: Subida logarítmica
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Subida logarítmica', 'pratica', 40, 'O caminho sobe rápido no começo e desacelera; posicione a restrição do logaritmo.', 1, 10
FROM Trilha WHERE nome_trilha = 'Função logarítmica';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -3,
    "y": -3.0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": 3.0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -2.4,
    "y": -3.80386,
    "largura": 0.5,
    "altura": 2.39229
  },
  {
    "tipo": "obstaculo",
    "x": -2.4,
    "y": 2.10111,
    "largura": 0.5,
    "altura": 5.79779
  },
  {
    "tipo": "obstaculo",
    "x": -1.5,
    "y": -3.03567,
    "largura": 0.5,
    "altura": 3.92866
  },
  {
    "tipo": "obstaculo",
    "x": -1.5,
    "y": 2.6557,
    "largura": 0.5,
    "altura": 4.68861
  },
  {
    "tipo": "obstaculo",
    "x": -0.2,
    "y": -2.36091,
    "largura": 0.5,
    "altura": 5.27817
  },
  {
    "tipo": "obstaculo",
    "x": -0.2,
    "y": 3.20264,
    "largura": 0.5,
    "altura": 3.59471
  },
  {
    "tipo": "obstaculo",
    "x": 1.2,
    "y": -1.87312,
    "largura": 0.5,
    "altura": 6.25376
  },
  {
    "tipo": "obstaculo",
    "x": 1.2,
    "y": 3.62467,
    "largura": 0.5,
    "altura": 2.75066
  },
  {
    "tipo": "obstaculo",
    "x": 2.7,
    "y": -1.48644,
    "largura": 0.5,
    "altura": 7.02711
  },
  {
    "tipo": "obstaculo",
    "x": 2.7,
    "y": 3.97147,
    "largura": 0.5,
    "altura": 2.05706
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função logarítmica' AND a.numero_atividade = 1 AND a.tipo = 'pratica';

-- Função logarítmica / fase 2: Reflexo logarítmico
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Reflexo logarítmico', 'pratica', 60, 'Reflita o logaritmo no eixo horizontal e controle seu deslocamento.', 2, 15
FROM Trilha WHERE nome_trilha = 'Função logarítmica';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -4,
    "y": 3.0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 3,
    "y": -3.0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -3.4,
    "y": -2.09977,
    "largura": 0.55,
    "altura": 5.80046
  },
  {
    "tipo": "obstaculo",
    "x": -3.4,
    "y": 3.81231,
    "largura": 0.55,
    "altura": 2.37537
  },
  {
    "tipo": "obstaculo",
    "x": -2.4,
    "y": -2.69827,
    "largura": 0.55,
    "altura": 4.60346
  },
  {
    "tipo": "obstaculo",
    "x": -2.4,
    "y": 2.96687,
    "largura": 0.55,
    "altura": 4.06625
  },
  {
    "tipo": "obstaculo",
    "x": -1,
    "y": -3.25936,
    "largura": 0.55,
    "altura": 3.48129
  },
  {
    "tipo": "obstaculo",
    "x": -1,
    "y": 2.27013,
    "largura": 0.55,
    "altura": 5.45974
  },
  {
    "tipo": "obstaculo",
    "x": 0.5,
    "y": -3.6872,
    "largura": 0.55,
    "altura": 2.62559
  },
  {
    "tipo": "obstaculo",
    "x": 0.5,
    "y": 1.77403,
    "largura": 0.55,
    "altura": 6.45194
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": -4.01676,
    "largura": 0.55,
    "altura": 1.96648
  },
  {
    "tipo": "obstaculo",
    "x": 2,
    "y": 1.40556,
    "largura": 0.55,
    "altura": 7.18888
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função logarítmica' AND a.numero_atividade = 2 AND a.tipo = 'pratica';

-- Função logarítmica / fase 3: Aproximação da assíntota
INSERT INTO Atividades (id_trilha, titulo, tipo, xp_base, descricao, numero_atividade, moeda_base)
SELECT id_trilha, 'Aproximação da assíntota', 'pratica', 80, 'Desloque e reflita horizontalmente o logaritmo; respeite o domínio junto à descida final.', 3, 20
FROM Trilha WHERE nome_trilha = 'Função logarítmica';
INSERT INTO Atividades_Pratica (id_atividade, media_movimentos, colisoes_malha)
SELECT a.id_atividade, 1, '[
  {
    "tipo": "inicio",
    "x": -3,
    "y": 3.0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "fim",
    "x": 4,
    "y": -3.0,
    "largura": 0.4,
    "altura": 0.4
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": -1.39099,
    "largura": 0.6,
    "altura": 7.21802
  },
  {
    "tipo": "obstaculo",
    "x": -2,
    "y": 4.00166,
    "largura": 0.6,
    "altura": 1.99667
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": -1.76104,
    "largura": 0.6,
    "altura": 6.47792
  },
  {
    "tipo": "obstaculo",
    "x": -0.5,
    "y": 3.67336,
    "largura": 0.6,
    "altura": 2.65328
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": -2.26003,
    "largura": 0.6,
    "altura": 5.47994
  },
  {
    "tipo": "obstaculo",
    "x": 1,
    "y": 3.24763,
    "largura": 0.6,
    "altura": 3.50473
  },
  {
    "tipo": "obstaculo",
    "x": 2.3,
    "y": -2.88734,
    "largura": 0.56,
    "altura": 4.22532
  },
  {
    "tipo": "obstaculo",
    "x": 2.3,
    "y": 2.72881,
    "largura": 0.56,
    "altura": 4.54238
  },
  {
    "tipo": "obstaculo",
    "x": 3.1,
    "y": -3.39317,
    "largura": 0.35,
    "altura": 3.21366
  },
  {
    "tipo": "obstaculo",
    "x": 3.1,
    "y": 2.22098,
    "largura": 0.35,
    "altura": 5.55804
  },
  {
    "tipo": "obstaculo",
    "x": 3.6,
    "y": -3.88121,
    "largura": 0.3,
    "altura": 2.23757
  },
  {
    "tipo": "obstaculo",
    "x": 3.6,
    "y": 1.81599,
    "largura": 0.3,
    "altura": 6.36801
  }
]'
FROM Atividades a JOIN Trilha t ON t.id_trilha = a.id_trilha
WHERE t.nome_trilha = 'Função logarítmica' AND a.numero_atividade = 3 AND a.tipo = 'pratica';

INSERT INTO Atividades (id_trilha, numero_atividade, titulo, descricao, tipo, xp_base, moeda_base)
SELECT id_trilha, 0, 'Retas e caminhos por trechos', 'Conceitos para os desafios desta trilha.', 'leitura', 0, 0 FROM Trilha WHERE nome_trilha='Função afim';
INSERT INTO Atividades_Leitura (id_atividade, textos, imagens)
SELECT a.id_atividade, '["Uma função afim tem a forma f(x) = a*x + b. O coeficiente a controla a inclinação e b controla a altura em x = 0.", "Para dois pontos distintos em x, calcule a = (y2-y1)/(x2-x1) e depois b = y1-a*x1.", "Se as passagens mudam de direção, use mais de uma reta em domínios diferentes. As alturas devem coincidir no encontro dos trechos.", "No parser atual, escreva o domínio na ordem menor<x<maior; por exemplo, -4<x<1. Ele amostra também os extremos."]', '[]' FROM Atividades a JOIN Trilha t ON t.id_trilha=a.id_trilha WHERE t.nome_trilha='Função afim' AND a.tipo='leitura' AND a.numero_atividade=0;

INSERT INTO Atividades (id_trilha, numero_atividade, titulo, descricao, tipo, xp_base, moeda_base)
SELECT id_trilha, 0, 'Vértice e abertura das parábolas', 'Conceitos para os desafios desta trilha.', 'leitura', 0, 0 FROM Trilha WHERE nome_trilha='Função quadrática';
INSERT INTO Atividades_Leitura (id_atividade, textos, imagens)
SELECT a.id_atividade, '["Uma função quadrática tem a forma a*x*x+b*x+c, com a diferente de zero.", "Na forma a*(x-h)*(x-h)+k, o vértice está em (h,k). O sinal de a define a concavidade.", "O módulo de a controla a abertura: valores maiores deixam a parábola mais fechada. Ajuste o vértice e depois a abertura.", "Observe as passagens próximas ao vértice e nas laterais. Uma reta entre os alvos pode cruzar paredes que a curva contorna."]', '[]' FROM Atividades a JOIN Trilha t ON t.id_trilha=a.id_trilha WHERE t.nome_trilha='Função quadrática' AND a.tipo='leitura' AND a.numero_atividade=0;

INSERT INTO Atividades (id_trilha, numero_atividade, titulo, descricao, tipo, xp_base, moeda_base)
SELECT id_trilha, 0, 'Módulo, reflexão e vértices', 'Conceitos para os desafios desta trilha.', 'leitura', 0, 0 FROM Trilha WHERE nome_trilha='Função modular';
INSERT INTO Atividades_Leitura (id_atividade, textos, imagens)
SELECT a.id_atividade, '["abs(x) representa o módulo e produz um gráfico em V.", "Em a*abs(x-h)+k, o vértice está em (h,k). Um a negativo inverte o V.", "Cada braço é uma reta, mas a mudança de inclinação acontece exatamente no vértice.", "Para dois vales, combine dois módulos em domínios diferentes e confira se eles se encontram sem salto."]', '[]' FROM Atividades a JOIN Trilha t ON t.id_trilha=a.id_trilha WHERE t.nome_trilha='Função modular' AND a.tipo='leitura' AND a.numero_atividade=0;

INSERT INTO Atividades (id_trilha, numero_atividade, titulo, descricao, tipo, xp_base, moeda_base)
SELECT id_trilha, 0, 'Crescimento e reflexão exponencial', 'Conceitos para os desafios desta trilha.', 'leitura', 0, 0 FROM Trilha WHERE nome_trilha='Função exponencial';
INSERT INTO Atividades_Leitura (id_atividade, textos, imagens)
SELECT a.id_atividade, '["pow(2,x) dobra quando x aumenta em uma unidade. O crescimento não tem inclinação constante.", "Em a*pow(2,x-h)+k, a muda a escala vertical e k desloca a curva para cima ou para baixo.", "Trocar x por -x produz decaimento. Um sinal negativo fora da potência também reflete a curva verticalmente.", "Observe onde o caminho é quase horizontal e onde ele fica íngreme. Isso ajuda a escolher a orientação e o deslocamento."]', '[]' FROM Atividades a JOIN Trilha t ON t.id_trilha=a.id_trilha WHERE t.nome_trilha='Função exponencial' AND a.tipo='leitura' AND a.numero_atividade=0;

INSERT INTO Atividades (id_trilha, numero_atividade, titulo, descricao, tipo, xp_base, moeda_base)
SELECT id_trilha, 0, 'Logaritmo e domínio', 'Conceitos para os desafios desta trilha.', 'leitura', 0, 0 FROM Trilha WHERE nome_trilha='Função logarítmica';
INSERT INTO Atividades_Leitura (id_atividade, textos, imagens)
SELECT a.id_atividade, '["ln(x) é o logaritmo natural e só é definido quando x é positivo.", "Para logaritmo na base 2, use ln(x)/ln(2). Em ln(x+c), o argumento precisa continuar positivo.", "O crescimento é rápido perto da fronteira do domínio e desacelera ao se afastar dela.", "Em ln(c-x), o argumento exige x<c. A reflexão horizontal muda o lado em que o gráfico fica íngreme."]', '[]' FROM Atividades a JOIN Trilha t ON t.id_trilha=a.id_trilha WHERE t.nome_trilha='Função logarítmica' AND a.tipo='leitura' AND a.numero_atividade=0;

COMMIT;
SET AUTOCOMMIT TRUE;

SELECT t.nome_trilha, a.numero_atividade, a.titulo, p.media_movimentos FROM Atividades a JOIN Trilha t ON t.id_trilha=a.id_trilha LEFT JOIN Atividades_Pratica p ON p.id_atividade=a.id_atividade ORDER BY t.numero_trilha,a.numero_atividade;
