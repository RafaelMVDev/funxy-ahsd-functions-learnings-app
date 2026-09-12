/* modelo_logico: */

CREATE TABLE Conquistas (
    id_conquista BIGINT PRIMARY KEY,
    valor_condicao BIGINT,
    descricao VARCHAR(500),
    moeda INT,
    tipo VARCHAR(50),
    nome VARCHAR(70)
);

CREATE TABLE Usuario (
    id_usuario BIGINT PRIMARY KEY,
    email VARCHAR(255) UNIQUE,
    senha_hash VARCHAR(255),
    nome VARCHAR(255),
    sequencia INT,
    xp BIGINT,
    moedas BIGINT
);

CREATE TABLE Itens (
    id_item BIGINT PRIMARY KEY,
    meta_dados TEXT,
    tipo VARCHAR(50),
    estilo VARCHAR(50),
    descricao VARCHAR(255)
);

CREATE TABLE Inventario (
    id_item BIGINT,
    equipado BOOLEAN,
    id_usuario BIGINT,
    PRIMARY KEY (id_item, id_usuario)
);

CREATE TABLE Item_Passe_Batalha (
    xp_necessario INTEGER,
    id_item BIGINT PRIMARY KEY
);

CREATE TABLE Item_Loja (
    valor INTEGER,
    id_item BIGINT PRIMARY KEY
);

CREATE TABLE Configuracao (
    id_config BIGINT,
    tema VARCHAR(30),
    idioma VARCHAR(60),
    notificacao BOOLEAN,
    id_usuario BIGINT,
    PRIMARY KEY (id_config, id_usuario)
);

CREATE TABLE Atividades (
    id_atividade BIGINT PRIMARY KEY,
    id_trilha BIGINT,
    titulo VARCHAR(100),
    tipo VARCHAR(40),
    xp_base INT,
    descricao TEXT,
    numero_atividade INT,
    moeda_base INT
);

CREATE TABLE Atividades_Pratica (
    media_movimentos INT,
    id_atividade BIGINT PRIMARY KEY
);

CREATE TABLE Atividades_Leitura (
    textos TEXT,
    imagens TEXT,
    id_atividade BIGINT PRIMARY KEY
);

CREATE TABLE Conquista_Usuario_Acessa (
    data DATETIME,
    id_conquista BIGINT,
    id_usuario BIGINT,
    PRIMARY KEY (id_usuario, id_conquista)
);

CREATE TABLE Atividades_Imagem (
    id_imagem BIGINT PRIMARY KEY,
    img_url VARCHAR(500),
    id_atividade BIGINT
);

CREATE TABLE Progresso (
    datetime_conclusao DATETIME,
    datetime_inicio DATETIME,
    id_usuario BIGINT,
    id_atividade BIGINT,
    id_progresso BIGINT PRIMARY KEY
);

CREATE TABLE Progresso_Pratica (
    posicao_atual TEXT,
    movimentos INT,
    id_progresso BIGINT PRIMARY KEY
);

CREATE TABLE Progresso_Leitura (
    pagina_atual INT,
    id_progresso BIGINT PRIMARY KEY
);
 
ALTER TABLE Inventario ADD CONSTRAINT FK_Inventario_2
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario (id_usuario)
    ON DELETE RESTRICT;
 
ALTER TABLE Inventario ADD CONSTRAINT FK_Inventario_3
    FOREIGN KEY (id_item)
    REFERENCES Itens (id_item);
 
ALTER TABLE Item_Passe_Batalha ADD CONSTRAINT FK_Item_Passe_Batalha_2
    FOREIGN KEY (id_item)
    REFERENCES Itens (id_item)
    ON DELETE CASCADE;
 
ALTER TABLE Item_Loja ADD CONSTRAINT FK_Item_Loja_2
    FOREIGN KEY (id_item)
    REFERENCES Itens (id_item)
    ON DELETE CASCADE;
 
ALTER TABLE Configuracao ADD CONSTRAINT FK_Configuracao_2
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario (id_usuario)
    ON DELETE CASCADE;
 
ALTER TABLE Atividades_Pratica ADD CONSTRAINT FK_Atividades_Pratica_2
    FOREIGN KEY (id_atividade)
    REFERENCES Atividades (id_atividade)
    ON DELETE CASCADE;
 
ALTER TABLE Atividades_Leitura ADD CONSTRAINT FK_Atividades_Leitura_2
    FOREIGN KEY (id_atividade)
    REFERENCES Atividades (id_atividade)
    ON DELETE CASCADE;
 
ALTER TABLE Conquista_Usuario_Acessa ADD CONSTRAINT FK_Conquista_Usuario_Acessa_1
    FOREIGN KEY (id_conquista)
    REFERENCES Conquistas (id_conquista);
 
ALTER TABLE Conquista_Usuario_Acessa ADD CONSTRAINT FK_Conquista_Usuario_Acessa_2
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario (id_usuario);
 
ALTER TABLE Atividades_Imagem ADD CONSTRAINT FK_Atividades_Imagem_2
    FOREIGN KEY (id_atividade)
    REFERENCES Atividades (id_atividade);
 
ALTER TABLE Progresso ADD CONSTRAINT FK_Progresso_2
    FOREIGN KEY (id_usuario)
    REFERENCES Usuario (id_usuario)
    ON DELETE CASCADE;
 
ALTER TABLE Progresso ADD CONSTRAINT FK_Progresso_3
    FOREIGN KEY (id_atividade)
    REFERENCES Atividades (id_atividade)
    ON DELETE CASCADE;
 
ALTER TABLE Progresso_Pratica ADD CONSTRAINT FK_Progresso_Pratica_2
    FOREIGN KEY (id_progresso)
    REFERENCES Progresso (id_progresso)
    ON DELETE CASCADE;
 
ALTER TABLE Progresso_Leitura ADD CONSTRAINT FK_Progresso_Leitura_2
    FOREIGN KEY (id_progresso)
    REFERENCES Progresso (id_progresso);