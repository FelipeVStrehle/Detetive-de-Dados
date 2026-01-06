-- ============================================================================
-- CASO 02: Rastreando Conexões
-- Tabela de logs de acesso ao servidor
-- ============================================================================

-- Criar tabela de logs de acesso
CREATE TABLE IF NOT EXISTS Logs_Acesso (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER,
    nome_usuario TEXT,
    hora_acesso TEXT,
    ip_origem TEXT,
    acao TEXT,
    FOREIGN KEY (usuario_id) REFERENCES Funcionarios(id)
);

-- Inserir dados de logs (incluindo acessos suspeitos na madrugada)
INSERT INTO Logs_Acesso (usuario_id, nome_usuario, hora_acesso, ip_origem, acao) VALUES
-- Acessos normais do dia anterior
(1, 'Marcus Chen', '18:45', '192.168.1.101', 'Login'),
(2, 'Sarah Parker', '19:12', '192.168.1.105', 'Logout'),
(3, 'Raj Patel', '20:05', '192.168.1.112', 'Login'),

-- Acessos suspeitos na madrugada (02:00 - 03:00)
(5, 'Alex Morgan', '02:17', '192.168.1.205', 'Acesso ao Projeto Nexus'),
(5, 'Alex Morgan', '02:23', '192.168.1.205', 'Download de arquivos'),
(7, 'Julia Santos', '02:35', '192.168.1.180', 'Tentativa de acesso negada'),
(3, 'Raj Patel', '02:48', '10.0.0.50', 'Login remoto'),

-- Acessos normais da manhã
(1, 'Marcus Chen', '08:30', '192.168.1.101', 'Login'),
(2, 'Sarah Parker', '08:45', '192.168.1.105', 'Login'),
(4, 'Chen Wei', '09:00', '192.168.1.115', 'Login');

-- Verificação: Consulta que deve ser a resposta do Caso 2
-- SELECT * FROM Logs_Acesso WHERE hora_acesso >= '02:00' AND hora_acesso <= '03:00';
