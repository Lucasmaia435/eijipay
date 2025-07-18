-- Criar tabelas principais
CREATE TABLE funcionario (
    matricula VARCHAR(50) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100),
    cpf VARCHAR(14) UNIQUE NOT NULL,
    cargo VARCHAR(100),
    data_admissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE lotacao (
    codigo SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    papel VARCHAR(50) NOT NULL
);

CREATE TABLE empregador (
    cnpj VARCHAR(18) PRIMARY KEY,
    razao_social VARCHAR(255) NOT NULL
);

CREATE TABLE evento_verba (
    codigo SERIAL PRIMARY KEY,
    descricao VARCHAR(255) NOT NULL,
    info_prov_desc TEXT
);

-- Tabela com foreign keys
CREATE TABLE recibo_pagamento (
    referencia VARCHAR(50) PRIMARY KEY,
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    competencia VARCHAR(20),
    valor_provento DECIMAL(15,2) DEFAULT 0,
    valor_desconto DECIMAL(15,2) DEFAULT 0,
    matricula_funcionario VARCHAR(50) NOT NULL,
    cnpj_empregador VARCHAR(18) NOT NULL,
    usuario_id INTEGER NOT NULL,
    
    CONSTRAINT fk_recibo_funcionario 
        FOREIGN KEY (matricula_funcionario) 
        REFERENCES funcionario(matricula) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
        
    CONSTRAINT fk_recibo_empregador 
        FOREIGN KEY (cnpj_empregador) 
        REFERENCES empregador(cnpj) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
        
    CONSTRAINT fk_recibo_usuario 
        FOREIGN KEY (usuario_id) 
        REFERENCES usuario(id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Tabelas de relacionamento N:N
CREATE TABLE recibo_evento (
    recibo_referencia VARCHAR(50),
    evento_codigo INTEGER,
    
    PRIMARY KEY (recibo_referencia, evento_codigo),
    
    CONSTRAINT fk_recibo_evento_recibo 
        FOREIGN KEY (recibo_referencia) 
        REFERENCES recibo_pagamento(referencia) 
        ON DELETE CASCADE ON UPDATE CASCADE,
        
    CONSTRAINT fk_recibo_evento_evento 
        FOREIGN KEY (evento_codigo) 
        REFERENCES evento_verba(codigo) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE lotado (
    matricula_funcionario VARCHAR(50),
    lotacao_codigo INTEGER,
    data_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fim TIMESTAMP,
    
    PRIMARY KEY (matricula_funcionario, lotacao_codigo),
    
    CONSTRAINT fk_lotado_funcionario 
        FOREIGN KEY (matricula_funcionario) 
        REFERENCES funcionario(matricula) 
        ON DELETE CASCADE ON UPDATE CASCADE,
        
    CONSTRAINT fk_lotado_lotacao 
        FOREIGN KEY (lotacao_codigo) 
        REFERENCES lotacao(codigo) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE controla (
    matricula_funcionario VARCHAR(50),
    lotacao_codigo INTEGER,
    data_inicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fim TIMESTAMP,
    
    PRIMARY KEY (matricula_funcionario, lotacao_codigo),
    
    CONSTRAINT fk_controla_funcionario 
        FOREIGN KEY (matricula_funcionario) 
        REFERENCES funcionario(matricula) 
        ON DELETE CASCADE ON UPDATE CASCADE,
        
    CONSTRAINT fk_controla_lotacao 
        FOREIGN KEY (lotacao_codigo) 
        REFERENCES lotacao(codigo) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cadastra_funcionario (
    usuario_id INTEGER,
    matricula_funcionario VARCHAR(50),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (usuario_id, matricula_funcionario),
    
    CONSTRAINT fk_cadastra_func_usuario 
        FOREIGN KEY (usuario_id) 
        REFERENCES usuario(id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
        
    CONSTRAINT fk_cadastra_func_funcionario 
        FOREIGN KEY (matricula_funcionario) 
        REFERENCES funcionario(matricula) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cadastra_evento (
    usuario_id INTEGER,
    evento_codigo INTEGER,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (usuario_id, evento_codigo),
    
    CONSTRAINT fk_cadastra_evento_usuario 
        FOREIGN KEY (usuario_id) 
        REFERENCES usuario(id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
        
    CONSTRAINT fk_cadastra_evento_evento 
        FOREIGN KEY (evento_codigo) 
        REFERENCES evento_verba(codigo) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cadastra_lotacao (
    usuario_id INTEGER,
    lotacao_codigo INTEGER,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (usuario_id, lotacao_codigo),
    
    CONSTRAINT fk_cadastra_lotacao_usuario 
        FOREIGN KEY (usuario_id) 
        REFERENCES usuario(id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
        
    CONSTRAINT fk_cadastra_lotacao_lotacao 
        FOREIGN KEY (lotacao_codigo) 
        REFERENCES lotacao(codigo) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Criar índices para melhor performance
CREATE INDEX idx_funcionario_cpf ON funcionario(cpf);
CREATE INDEX idx_recibo_competencia ON recibo_pagamento(competencia);
CREATE INDEX idx_recibo_data ON recibo_pagamento(data);
CREATE INDEX idx_usuario_email ON usuario(email);

-- Comentários nas tabelas
COMMENT ON TABLE funcionario IS 'Tabela de funcionários da empresa';
COMMENT ON TABLE lotacao IS 'Tabela de lotações/departamentos';
COMMENT ON TABLE usuario IS 'Tabela de usuários do sistema';
COMMENT ON TABLE empregador IS 'Tabela de empregadores';
COMMENT ON TABLE evento_verba IS 'Tabela de eventos de verba (proventos/descontos)';
COMMENT ON TABLE recibo_pagamento IS 'Tabela de recibos de pagamento';
COMMENT ON TABLE recibo_evento IS 'Relacionamento N:N entre recibos e eventos';
COMMENT ON TABLE lotado IS 'Relacionamento N:N - funcionários lotados';
COMMENT ON TABLE controla IS 'Relacionamento N:N - funcionários que controlam lotações';
COMMENT ON TABLE cadastra_funcionario IS 'Relacionamento N:N - usuários que cadastram funcionários';
COMMENT ON TABLE cadastra_evento IS 'Relacionamento N:N - usuários que cadastram eventos';
COMMENT ON TABLE cadastra_lotacao IS 'Relacionamento N:N - usuários que cadastram lotações';