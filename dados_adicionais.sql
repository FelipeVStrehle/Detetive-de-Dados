-- ============================================================================
-- DADOS ADICIONAIS PARA SQL ENIGMAS - O DETETIVE DE DADOS
-- ============================================================================

-- Adiciona colunas na tabela Funcionarios
ALTER TABLE Funcionarios ADD COLUMN salario REAL;
ALTER TABLE Funcionarios ADD COLUMN email TEXT;
ALTER TABLE Funcionarios ADD COLUMN data_contratacao TEXT;

-- Atualiza os funcionários originais com salário, email e data de contratação
UPDATE Funcionarios SET salario = 4500.00, email = 'carlos.silva@datacorp.com', data_contratacao = '2023-02-10' WHERE id_funcionario = 'CARLOS_JR';
UPDATE Funcionarios SET salario = 9800.00, email = 'sofia.alves@datacorp.com', data_contratacao = '2019-05-22' WHERE id_funcionario = 'SOFIA_SR';
UPDATE Funcionarios SET salario = 6200.00, email = 'pedro.martins@datacorp.com', data_contratacao = '2021-08-15' WHERE id_funcionario = 'PEDRO_QA';
UPDATE Funcionarios SET salario = 18000.00, email = 'marcos.oliveira@datacorp.com', data_contratacao = '2017-03-01' WHERE id_funcionario = 'E-774';

-- Adiciona colunas extras na tabela Arquivos_Servidor
ALTER TABLE Arquivos_Servidor ADD COLUMN tamanho_kb INTEGER;
ALTER TABLE Arquivos_Servidor ADD COLUMN tipo TEXT;

-- Adiciona colunas extras na tabela Logs_Acesso_Sistema
ALTER TABLE Logs_Acesso_Sistema ADD COLUMN ip_origem TEXT;
ALTER TABLE Logs_Acesso_Sistema ADD COLUMN tipo_acesso TEXT;
ALTER TABLE Logs_Acesso_Sistema ADD COLUMN sistema_operacional TEXT;

-- Adiciona colunas extras na tabela Transferencias_Arquivos
ALTER TABLE Transferencias_Arquivos ADD COLUMN destino_ip TEXT;
ALTER TABLE Transferencias_Arquivos ADD COLUMN tamanho_transferido_kb INTEGER;

-- ============================================================================
-- TABELA: Funcionarios
-- Adiciona mais funcionários de diferentes departamentos
-- ============================================================================

INSERT INTO Funcionarios (id_funcionario, nome_completo, cargo, departamento, data_contratacao, salario, email) VALUES
-- Departamento de RH
('RH-101', 'Ana Paula Costa', 'Gerente de RH', 'Recursos Humanos', '2020-03-15', 8500.00, 'ana.costa@datacorp.com'),
('RH-102', 'Roberto Lima', 'Analista de RH', 'Recursos Humanos', '2021-06-20', 5200.00, 'roberto.lima@datacorp.com'),

-- Departamento Financeiro
('FIN-201', 'Juliana Ferreira', 'Diretora Financeira', 'Financeiro', '2018-01-10', 15000.00, 'juliana.ferreira@datacorp.com'),
('FIN-202', 'Marcos Souza', 'Contador', 'Financeiro', '2019-08-25', 6800.00, 'marcos.souza@datacorp.com'),
('FIN-203', 'Carla Mendes', 'Analista Financeiro', 'Financeiro', '2022-02-14', 5500.00, 'carla.mendes@datacorp.com'),

-- Departamento de Marketing
('MKT-301', 'Beatriz Santos', 'Gerente de Marketing', 'Marketing', '2020-05-18', 9200.00, 'beatriz.santos@datacorp.com'),
('MKT-302', 'Felipe Rocha', 'Designer Gráfico', 'Marketing', '2021-09-10', 5800.00, 'felipe.rocha@datacorp.com'),
('MKT-303', 'Larissa Oliveira', 'Social Media', 'Marketing', '2023-01-05', 4500.00, 'larissa.oliveira@datacorp.com'),

-- Departamento de Vendas
('VEN-401', 'Ricardo Almeida', 'Diretor de Vendas', 'Vendas', '2019-04-22', 12000.00, 'ricardo.almeida@datacorp.com'),
('VEN-402', 'Camila Barbosa', 'Executiva de Contas', 'Vendas', '2021-11-30', 7200.00, 'camila.barbosa@datacorp.com'),
('VEN-403', 'Thiago Cardoso', 'Representante Comercial', 'Vendas', '2022-07-08', 5000.00, 'thiago.cardoso@datacorp.com'),

-- Departamento de Suporte
('SUP-501', 'Fernanda Dias', 'Coordenadora de Suporte', 'Suporte Técnico', '2020-10-12', 7500.00, 'fernanda.dias@datacorp.com'),
('SUP-502', 'Lucas Pereira', 'Analista de Suporte', 'Suporte Técnico', '2022-03-25', 4800.00, 'lucas.pereira@datacorp.com'),
('SUP-503', 'Mariana Gomes', 'Técnica de Suporte', 'Suporte Técnico', '2023-05-17', 4200.00, 'mariana.gomes@datacorp.com'),

-- Departamento de Infraestrutura
('INF-601', 'Gabriel Nunes', 'Administrador de Redes', 'Infraestrutura', '2019-02-28', 8200.00, 'gabriel.nunes@datacorp.com'),
('INF-602', 'Patricia Silva', 'Engenheira de DevOps', 'Infraestrutura', '2021-04-15', 9500.00, 'patricia.silva@datacorp.com'),

-- Estagiários
('EST-701', 'João Pedro Santos', 'Estagiário de TI', 'Desenvolvimento', '2024-08-01', 1800.00, 'joao.santos@datacorp.com'),
('EST-702', 'Maria Eduarda Lima', 'Estagiária de Marketing', 'Marketing', '2024-08-01', 1800.00, 'maria.lima@datacorp.com');


-- ============================================================================
-- TABELA: Arquivos_Servidor
-- Adiciona mais arquivos no servidor (documentos, configs, backups)
-- ============================================================================

INSERT INTO Arquivos_Servidor (id_arquivo, nome_arquivo, id_criador, data_criacao, data_modificacao, tamanho_kb, tipo) VALUES
-- Arquivos de configuração
(101, 'config_servidor.conf', 'INF-601', '2024-01-15 10:30:00', '2025-09-10 14:25:00', 45, 'Configuração'),
(102, 'database_config.ini', 'INF-602', '2024-02-20 09:15:00', '2025-08-22 11:10:00', 23, 'Configuração'),
(103, 'firewall_rules.conf', 'INF-601', '2024-03-10 16:40:00', '2025-10-15 13:30:00', 67, 'Configuração'),

-- Logs adicionais (alguns suspeitos)
(104, 'acesso_sistema.log', 'CARLOS_JR', '2025-10-20 18:00:00', '2025-10-21 02:15:00', 850, 'Log'),
(105, 'erro_rede.log', 'INF-601', '2025-10-20 20:30:00', '2025-10-21 01:20:00', 320, 'Log'),
(106, 'backup_automatico.log', 'SOFIA_SR', '2025-10-21 00:30:00', '2025-10-21 00:35:00', 125, 'Log'),
(107, 'firewall_alert.log', 'INF-601', '2025-10-21 01:45:00', '2025-10-21 01:50:00', 240, 'Log'),

-- Documentos do Projeto Nexus
(108, 'projeto_nexus_visao_geral.pdf', 'E-774', '2024-06-10 14:00:00', '2025-09-18 16:30:00', 2400, 'Documento'),
(109, 'especificacoes_tecnicas_nexus.docx', 'SOFIA_SR', '2024-07-15 11:20:00', '2025-10-10 10:15:00', 1850, 'Documento'),
(110, 'documento_secreto.pdf', 'E-774', '2024-08-01 09:00:00', '2025-10-20 23:45:00', 5600, 'Documento'),
(111, 'roadmap_nexus_2025.xlsx', 'PEDRO_QA', '2024-09-05 15:30:00', '2025-09-30 14:20:00', 890, 'Documento'),

-- Backups
(112, 'backup_diario_20_10.bkp', 'SOFIA_SR', '2025-10-20 23:00:00', '2025-10-20 23:30:00', 15000, 'Backup'),
(113, 'backup_diario_21_10.bkp', 'SOFIA_SR', '2025-10-21 00:30:00', '2025-10-21 00:45:00', 15200, 'Backup'),

-- Códigos fonte
(114, 'authentication_module.py', 'CARLOS_JR', '2025-08-15 10:00:00', '2025-10-18 16:40:00', 340, 'Código'),
(115, 'data_encryption.py', 'SOFIA_SR', '2025-07-20 14:30:00', '2025-10-12 11:25:00', 520, 'Código'),
(116, 'api_gateway.js', 'PEDRO_QA', '2025-06-10 09:15:00', '2025-09-28 15:50:00', 780, 'Código'),

-- Relatórios
(117, 'relatorio_mensal_outubro.pdf', 'E-774', '2025-10-01 08:00:00', '2025-10-15 17:30:00', 1200, 'Relatório'),
(118, 'analise_seguranca_q3.pdf', 'INF-601', '2025-09-25 16:00:00', '2025-09-25 17:45:00', 3400, 'Relatório');


-- ============================================================================
-- TABELA: Logs_Acesso_Sistema
-- Adiciona mais logins (normais e suspeitos) para enriquecer investigação
-- ============================================================================

INSERT INTO Logs_Acesso_Sistema (id_log, id_funcionario, timestamp_login, ip_origem, tipo_acesso, sistema_operacional) VALUES
-- Acessos normais do dia 20/10
(201, 'SOFIA_SR', '2025-10-20 08:15:00', '192.168.1.45', 'Local', 'Windows 11'),
(202, 'CARLOS_JR', '2025-10-20 08:30:00', '192.168.1.47', 'Local', 'Linux Ubuntu'),
(203, 'PEDRO_QA', '2025-10-20 09:00:00', '192.168.1.48', 'Local', 'macOS'),
(204, 'E-774', '2025-10-20 09:30:00', '192.168.1.20', 'Local', 'Windows 11'),
(205, 'INF-601', '2025-10-20 10:00:00', '192.168.1.55', 'Local', 'Linux Ubuntu'),
(206, 'RH-101', '2025-10-20 08:45:00', '192.168.1.60', 'Local', 'Windows 10'),
(207, 'MKT-301', '2025-10-20 09:15:00', '192.168.1.65', 'Local', 'macOS'),

-- Acessos da tarde do dia 20/10
(208, 'FIN-201', '2025-10-20 14:00:00', '192.168.1.70', 'Local', 'Windows 11'),
(209, 'VEN-401', '2025-10-20 14:30:00', '192.168.1.75', 'Local', 'Windows 10'),
(210, 'SUP-501', '2025-10-20 15:00:00', '192.168.1.80', 'Local', 'Windows 11'),

-- Saídas normais fim de expediente 20/10
(211, 'SOFIA_SR', '2025-10-20 18:10:00', '192.168.1.45', 'Logout', 'Windows 11'),
(212, 'PEDRO_QA', '2025-10-20 18:25:00', '192.168.1.48', 'Logout', 'macOS'),
(213, 'RH-101', '2025-10-20 18:00:00', '192.168.1.60', 'Logout', 'Windows 10'),

-- MADRUGADA DO DIA 21/10 - Timeline do crime
-- 00h - Backup da Sofia (INOCENTE)
(214, 'SOFIA_SR', '2025-10-21 00:10:15', '192.168.1.45', 'Remoto VPN', 'Windows 11'),
(215, 'SOFIA_SR', '2025-10-21 00:45:22', '192.168.1.45', 'Logout', 'Windows 11'),

-- 01h - Pedro fazendo testes noturnos (INOCENTE)
(216, 'PEDRO_QA', '2025-10-21 01:05:42', '192.168.1.48', 'Remoto VPN', 'macOS'),
(217, 'PEDRO_QA', '2025-10-21 01:35:18', '192.168.1.48', 'Logout', 'macOS'),

-- 01h50 - Carlos detecta invasor e tenta defender (HERÓI)
(218, 'CARLOS_JR', '2025-10-21 01:50:32', '192.168.1.47', 'Remoto VPN', 'Linux Ubuntu'),
(219, 'CARLOS_JR', '2025-10-21 02:02:45', '192.168.1.47', 'Logout Forçado', 'Linux Ubuntu'),

-- 02h13 - Marcos faz login inicial normal
(220, 'E-774', '2025-10-21 02:13:21', '192.168.1.20', 'Local', 'Windows 11'),

-- 02h14 - Marcos usa credenciais roubadas do Carlos (CRIMINOSO)
(221, 'E-774', '2025-10-21 02:14:05', '10.0.0.99', 'Remoto SSH', 'Linux Unknown'),

-- 02h30 - Marcos faz logout após o crime
(222, 'E-774', '2025-10-21 02:30:18', '192.168.1.20', 'Logout', 'Windows 11'),

-- Manhã do dia 21/10 - Retorno normal
(223, 'SOFIA_SR', '2025-10-21 08:00:00', '192.168.1.45', 'Local', 'Windows 11'),
(224, 'CARLOS_JR', '2025-10-21 08:15:00', '192.168.1.47', 'Local', 'Linux Ubuntu'),
(225, 'PEDRO_QA', '2025-10-21 08:20:00', '192.168.1.48', 'Local', 'macOS'),
(226, 'INF-601', '2025-10-21 08:10:00', '192.168.1.55', 'Local', 'Linux Ubuntu');


-- ============================================================================
-- TABELA: Transferencias_Arquivos
-- Adiciona mais transferências (normais e suspeitas)
-- ============================================================================

INSERT INTO Transferencias_Arquivos (id_transferencia, id_arquivo, id_funcionario_acao, id_credencial_usada, tipo_transferencia, timestamp_transferencia, destino_ip, tamanho_transferido_kb) VALUES
-- Transferências normais do dia 20/10
(301, 108, 'E-774', 'E-774', 'Interna', '2025-10-20 10:30:00', '192.168.1.50', 2400),
(302, 109, 'SOFIA_SR', 'SOFIA_SR', 'Interna', '2025-10-20 11:15:00', '192.168.1.48', 1850),
(303, 111, 'PEDRO_QA', 'PEDRO_QA', 'Interna', '2025-10-20 14:20:00', '192.168.1.47', 890),
(304, 114, 'CARLOS_JR', 'CARLOS_JR', 'Interna', '2025-10-20 16:45:00', '192.168.1.55', 340),

-- Backup da Sofia - MADRUGADA 21/10 (INOCENTE)
(305, 112, 'SOFIA_SR', 'SOFIA_SR', 'Interna', '2025-10-21 00:30:15', '192.168.1.90', 15000),
(306, 113, 'SOFIA_SR', 'SOFIA_SR', 'Interna', '2025-10-21 00:40:28', '192.168.1.90', 15200),

-- Testes do Pedro - MADRUGADA 21/10 (INOCENTE)
(307, 116, 'PEDRO_QA', 'PEDRO_QA', 'Interna', '2025-10-21 01:15:30', '192.168.1.48', 780),

-- Carlos tentando defender - MADRUGADA 21/10 (HERÓI)
(308, 104, 'CARLOS_JR', 'CARLOS_JR', 'Interna', '2025-10-21 01:52:45', '192.168.1.55', 850),

-- CRIME: Marcos usando credenciais do Carlos (CRIMINOSO)
(309, 110, 'E-774', 'CARLOS_JR', 'Externa', '2025-10-21 02:14:38', '203.0.113.50', 5600),

-- Transferências normais manhã 21/10
(310, 115, 'SOFIA_SR', 'SOFIA_SR', 'Interna', '2025-10-21 09:30:00', '192.168.1.47', 520),
(311, 117, 'E-774', 'E-774', 'Interna', '2025-10-21 10:00:00', '192.168.1.50', 1200),
(312, 118, 'INF-601', 'INF-601', 'Interna', '2025-10-21 11:15:00', '192.168.1.60', 3400);


-- ============================================================================
-- TABELA: Projetos
-- Adiciona mais projetos além do Projeto Nexus
-- ============================================================================

INSERT INTO Projetos (id_projeto, nome_projeto, descricao, data_inicio, data_fim_prevista, status, orcamento) VALUES
('PROJ-001', 'Projeto Nexus', 'Sistema de IA avançada para análise preditiva de dados', '2024-01-15', '2025-12-31', 'Em Andamento', 5000000.00),
('PROJ-002', 'Portal do Cliente', 'Plataforma web para autoatendimento de clientes', '2024-03-01', '2025-06-30', 'Em Andamento', 800000.00),
('PROJ-003', 'App Mobile Vendas', 'Aplicativo mobile para equipe de vendas', '2024-05-10', '2025-08-15', 'Em Andamento', 450000.00),
('PROJ-004', 'Sistema ERP', 'Integração de sistemas empresariais', '2023-08-20', '2025-03-31', 'Em Andamento', 1200000.00),
('PROJ-005', 'Dashboard Analytics', 'Painéis de visualização de dados', '2024-09-01', '2025-11-30', 'Em Andamento', 350000.00),
('PROJ-006', 'Modernização Infraestrutura', 'Migração para cloud e atualização de servidores', '2024-02-15', '2025-07-31', 'Em Andamento', 900000.00),
('PROJ-007', 'Chatbot Atendimento', 'IA conversacional para suporte ao cliente', '2024-10-01', '2026-02-28', 'Planejamento', 600000.00);


-- ============================================================================
-- TABELA: Alocacao_Projeto
-- Define quem trabalha em quais projetos
-- ============================================================================

INSERT INTO Alocacao_Projeto (id_alocacao, id_projeto, id_funcionario, data_alocacao, papel, horas_semanais) VALUES
-- Projeto Nexus (o principal do jogo)
(401, 'PROJ-001', 'E-774', '2024-01-15', 'Diretor Responsável', 40),
(402, 'PROJ-001', 'SOFIA_SR', '2024-01-20', 'Desenvolvedora Líder', 40),
(403, 'PROJ-001', 'CARLOS_JR', '2024-02-01', 'Desenvolvedor', 40),
(404, 'PROJ-001', 'PEDRO_QA', '2024-02-10', 'QA Lead', 35),
(405, 'PROJ-001', 'INF-602', '2024-01-25', 'DevOps Engineer', 30),

-- Portal do Cliente
(406, 'PROJ-002', 'SOFIA_SR', '2024-03-01', 'Consultora Técnica', 10),
(407, 'PROJ-002', 'EST-701', '2024-08-01', 'Estagiário', 20),
(408, 'PROJ-002', 'SUP-501', '2024-03-15', 'Coordenadora de Requisitos', 15),

-- App Mobile Vendas
(409, 'PROJ-003', 'VEN-401', '2024-05-10', 'Gestor do Produto', 10),
(410, 'PROJ-003', 'CARLOS_JR', '2024-05-15', 'Desenvolvedor Backend', 15),
(411, 'PROJ-003', 'MKT-302', '2024-05-20', 'Designer UX/UI', 25),

-- Sistema ERP
(412, 'PROJ-004', 'FIN-201', '2023-08-20', 'Patrocinadora', 5),
(413, 'PROJ-004', 'INF-601', '2023-09-01', 'Arquiteto de Sistemas', 25),
(414, 'PROJ-004', 'RH-101', '2023-09-10', 'Analista de Processos', 10),

-- Dashboard Analytics
(415, 'PROJ-005', 'E-774', '2024-09-01', 'Sponsor Executivo', 5),
(416, 'PROJ-005', 'PEDRO_QA', '2024-09-05', 'Analista de Dados', 20),

-- Modernização Infraestrutura
(417, 'PROJ-006', 'INF-601', '2024-02-15', 'Gerente de Projeto', 40),
(418, 'PROJ-006', 'INF-602', '2024-02-15', 'Engenheira Líder', 40),

-- Chatbot Atendimento
(419, 'PROJ-007', 'SUP-501', '2024-10-01', 'Product Owner', 15),
(420, 'PROJ-007', 'EST-701', '2024-10-01', 'Desenvolvedor Junior', 25);


-- ============================================================================
-- VIEW: View_Funcionarios_Nexus (para o Caso 01)
-- Cria view que filtra apenas funcionários do Projeto Nexus
-- ============================================================================

CREATE VIEW IF NOT EXISTS View_Funcionarios_Nexus AS
SELECT DISTINCT
    f.id_funcionario,
    f.nome_completo,
    f.cargo,
    f.departamento,
    ap.papel AS papel_no_projeto
FROM Funcionarios f
INNER JOIN Alocacao_Projeto ap ON f.id_funcionario = ap.id_funcionario
WHERE ap.id_projeto = 'PROJ-001'
ORDER BY f.nome_completo;


-- ============================================================================
-- VERIFICAÇÕES E CONSULTAS DE TESTE
-- ============================================================================

-- Verificar total de funcionários por departamento
-- SELECT departamento, COUNT(*) as total
-- FROM Funcionarios
-- GROUP BY departamento
-- ORDER BY total DESC;

-- Verificar arquivos suspeitos modificados na madrugada
-- SELECT nome_arquivo, data_modificacao
-- FROM Arquivos_Servidor
-- WHERE data_modificacao LIKE '%2025-10-21 0%'
--    OR data_modificacao LIKE '%2025-10-21 01%'
--    OR data_modificacao LIKE '%2025-10-21 02%'
-- ORDER BY data_modificacao;

-- Verificar transferências externas (deveria mostrar o crime)
-- SELECT f.nome_completo, a.nome_arquivo, t.id_credencial_usada, t.timestamp_transferencia
-- FROM Funcionarios f
-- JOIN Transferencias_Arquivos t ON f.id_funcionario = t.id_funcionario_acao
-- JOIN Arquivos_Servidor a ON a.id_arquivo = t.id_arquivo
-- WHERE t.tipo_transferencia = 'Externa';

-- Verificar logins suspeitos na madrugada
-- SELECT id_funcionario, timestamp_login, ip_origem, tipo_acesso
-- FROM Logs_Acesso_Sistema
-- WHERE timestamp_login LIKE '%2025-10-21 0%'
--    OR timestamp_login LIKE '%2025-10-21 01%'
--    OR timestamp_login LIKE '%2025-10-21 02%'
-- ORDER BY timestamp_login;

-- ============================================================================
-- FIM DO ARQUIVO
-- ============================================================================
-- Total de registros adicionados:
-- - Funcionarios: +18 funcionários
-- - Arquivos_Servidor: +18 arquivos
-- - Logs_Acesso_Sistema: +26 logs de acesso
-- - Transferencias_Arquivos: +12 transferências
-- - Projetos: +7 projetos
-- - Alocacao_Projeto: +20 alocações
-- - View_Funcionarios_Nexus: 1 view criada
-- ============================================================================
