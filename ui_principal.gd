extends Control

# Nossas referências para os nós da interface
@onready var grid_resultados = $Painel_Resultados/ScrollContainer/GridResultados
@onready var area_montagem = $Painel_Console/Panel/ScrollContainer_Montagem/Area_Montagem
@onready var feedback_label = $feedback_label
@onready var missao_label = $Painel_Missao/Divisor_missao/Label

# Referências para os botões de categoria
@onready var btn_todos = $Painel_Console/VBox_Blocos/HBox_Categorias/Btn_Todos
@onready var btn_comandos = $Painel_Console/VBox_Blocos/HBox_Categorias/Btn_Comandos
@onready var btn_operadores = $Painel_Console/VBox_Blocos/HBox_Categorias/Btn_Operadores
@onready var btn_dados = $Painel_Console/VBox_Blocos/HBox_Categorias/Btn_Dados

# --- DB REATIVADO (instância lazy para evitar crash no editor) ---
var db = null  # Será instanciado apenas em runtime, não no editor
var db_aberto = false  # Flag de controle para lazy loading

# --- SISTEMA DE CASOS ---
var caso_atual = 1  # Número do caso sendo jogado
var imagem_atual = "res://assets/imagens/Ada_Lovelace_SQL.png"  # Imagem padrão

# --- SISTEMA DE CATEGORIAS DE BLOCOS ---
var categoria_atual = "todos"  # Categoria de blocos selecionada: "todos", "comandos", "operadores", "dados"
var blocos_disponiveis_completos = []  # Array com todos os blocos do caso atual

var casos = {
	1: {
		"titulo": "Caso 01: Mapeando o Território",
		"descricao": "Ada: Delegado Turing, acabamos de receber o relatório de incidente. Às 02:17h da madrugada, houve um vazamento de dados classificados do Projeto Nexus. Precisamos começar do básico.\n\nVocê tem uma VIEW especial chamada 'View_Funcionarios_Nexus' que já filtra apenas funcionários com acesso oficial ao projeto. Mostre o NOME COMPLETO de todos eles. Essa será nossa base de suspeitos iniciais.",
		"blocos_disponiveis": ["FROM", "View_Funcionarios_Nexus", "SELECT", "nome_completo"],
		"resposta_correta": ["SELECT", "nome_completo", "FROM", "View_Funcionarios_Nexus"],
		"mensagem_sucesso": "Recebido. Três nomes na lista oficial: Carlos Silva, Pedro Martins e Marcos Oliveira. Lista limpa demais... nenhuma anomalia aparente. O invasor não seria tão óbvio. Precisamos investigar os departamentos onde essas pessoas trabalham.",
		"imagem": "res://assets/imagens/Ada_Lovelace_SQL.png",
		"dicas": [
			"Use SELECT para escolher quais colunas quer ver",
			"Use FROM para indicar de qual tabela/view você quer buscar",
			"A estrutura básica é: SELECT nome_coluna FROM nome_tabela",
			"Neste caso específico: SELECT nome_completo FROM View_Funcionarios_Nexus"
		],
		"proximo_caso": 2
	},
	2: {
		"titulo": "Caso 02: Filtrando Suspeitos",
		"descricao": "Ada: Analisando o tipo de ataque... acesso root, bypass de firewall, criptografia personalizada. Esse não foi um usuário comum, foi alguém com CONHECIMENTO TÉCNICO avançado.\n\nVamos filtrar! Na tabela 'Funcionarios', mostre o NOME COMPLETO e CARGO de todos do departamento 'Desenvolvimento'. Use WHERE para filtrar apenas esse departamento. Precisamos saber quem tem essas habilidades.",
		"blocos_disponiveis": ["WHERE", "departamento", "=", "'Desenvolvimento'", "FROM", "Funcionarios", "SELECT", "cargo", ",", "nome_completo", "departamento"],
		"resposta_correta": ["SELECT", "nome_completo", ",", "cargo", "FROM", "Funcionarios", "WHERE", "departamento", "=", "'Desenvolvimento'"],
		"mensagem_sucesso": "Três pessoas no departamento de Desenvolvimento: Carlos Silva (Programador Júnior), Sofia Alves (Desenvolvedora Sênior) e Pedro Martins (Analista de QA). Qualquer um deles possui conhecimento técnico suficiente para o ataque. Vamos investigar os arquivos do sistema.",
		"imagem": "res://assets/imagens/Ada_Lovelace_SQL.png",
		"dicas": [
			"Use SELECT para escolher múltiplas colunas (separe com vírgula)",
			"Use WHERE para filtrar apenas um departamento específico",
			"A estrutura é: SELECT col1, col2 FROM tabela WHERE condição = 'valor'",
			"Valores de texto como 'Desenvolvimento' precisam estar entre aspas simples"
		],
		"proximo_caso": 3
	},
	3: {
		"titulo": "Caso 03: Rastros no Servidor",
		"descricao": "Ada: Regra número um da investigação digital: TODO invasor deixa rastros. Arquivos de log (.log) são como pegadas digitais - registram cada ação no sistema.\n\nNa tabela 'Arquivos_Servidor', busque todos os arquivos que TERMINAM com '.log'. Mostre o NOME DO ARQUIVO e DATA DE MODIFICAÇÃO. Use o operador LIKE com o padrão '%.log' - o símbolo % representa 'qualquer texto antes'.",
		"blocos_disponiveis": ["LIKE", "'%.log'", "WHERE", "nome_arquivo", "FROM", "Arquivos_Servidor", "*", "data_modificacao", ",", "SELECT", "nome_arquivo"],
		"resposta_correta": ["SELECT", "nome_arquivo", ",", "data_modificacao", "FROM", "Arquivos_Servidor", "WHERE", "nome_arquivo", "LIKE", "'%.log'"],
		"mensagem_sucesso": "Três arquivos de log encontrados: 'acesso_sistema.log', 'erro_rede.log' e... espere. Tem um arquivo MUITO suspeito aqui: 'x0A_1g_k3.log'. Esse nome é criptografado! Definitivamente NÃO é padrão do sistema. Pode ser uma pista crucial!",
		"imagem": "res://assets/imagens/Ada_Lovelace_SQL.png",
		"dicas": [
			"Use LIKE com % para buscar padrões. '%.log' busca tudo que TERMINA com .log",
			"SELECT permite escolher múltiplas colunas separadas por vírgula",
			"A estrutura é: SELECT colunas FROM tabela WHERE coluna LIKE 'padrão'",
			"O padrão '%.log' significa: qualquer texto (%) seguido de .log"
		],
		"proximo_caso": 4
	},
	4: {
		"titulo": "Caso 04: A Hora do Crime",
		"descricao": "Ada: Encontramos um arquivo suspeito, mas precisamos CONECTÁ-LO ao crime. O ataque ocorreu na madrugada do dia 2025-10-21. Vamos verificar se esse log foi modificado EXATAMENTE nesse dia.\n\nBusque arquivos .log que foram modificados no dia '2025-10-21'. Você vai precisar combinar DUAS condições com AND: (1) nome termina com .log E (2) data_modificacao contém '2025-10-21'. Use LIKE '%2025-10-21%' para encontrar essa data.",
		"blocos_disponiveis": ["'%2025-10-21%'", "LIKE", "data_modificacao", "AND", "'%.log'", "nome_arquivo", "WHERE", "*", "Arquivos_Servidor", "FROM", ",", "SELECT", "data_modificacao", "nome_arquivo", "LIKE"],
		"resposta_correta": ["SELECT", "nome_arquivo", ",", "data_modificacao", "FROM", "Arquivos_Servidor", "WHERE", "nome_arquivo", "LIKE", "'%.log'", "AND", "data_modificacao", "LIKE", "'%2025-10-21%'"],
		"mensagem_sucesso": "CONFIRMADO! O arquivo 'x0A_1g_k3.log' foi modificado às 2025-10-21 01:50:32 - exatamente no HORÁRIO DO ATAQUE! Esse é nosso alvo principal. Vou enviar imediatamente para a Ana Luíza fazer análise forense desse arquivo!",
		"imagem": "res://assets/imagens/Ada_Lovelace_SQL.png",
		"dicas": [
			"Use AND para combinar múltiplas condições. Ambas precisam ser verdadeiras",
			"LIKE '%2025-10-21%' busca qualquer texto que CONTENHA essa data",
			"A estrutura é: WHERE condição1 AND condição2",
			"Você precisa verificar: nome termina com .log E data contém 2025-10-21"
		],
		"proximo_caso": 5
	},
	5: {
		"titulo": "Caso 05: Organizando Evidências",
		"descricao": "Ada: Enviei o arquivo suspeito para a Ana Luíza analisar. Enquanto isso, vou verificar as MOTIVAÇÕES financeiras. Em crimes corporativos, dinheiro é sempre um fator.\n\nNa tabela 'Funcionarios', mostre NOME COMPLETO, CARGO e SALÁRIO de TODOS os funcionários, mas ORDENE do MAIOR para o MENOR salário. Use ORDER BY salario DESC (DESC = decrescente). Vamos ver quem tem mais a perder... ou ganhar.",
		"blocos_disponiveis": ["DESC", "ASC", "salario", "ORDER BY", "Funcionarios", "FROM", "departamento", ",", "cargo", "nome_completo", "SELECT", ",", "salario"],
		"resposta_correta": ["SELECT", "nome_completo", ",", "cargo", ",", "salario", "FROM", "Funcionarios", "ORDER BY", "salario", "DESC"],
		"mensagem_sucesso": "Interessante! Topo da lista: Marcos Oliveira (R$ 18.000 - Diretor), Juliana Ferreira (R$ 15.000), Ricardo Almeida (R$ 12.000)... Marcos ganha MUITO bem, mas também tem MUITO a perder. Roubar dados do próprio projeto? Arriscado. Preciso investigar mais antes de suspeitar dele.",
		"imagem": "res://assets/imagens/Ada_Lovelace_SQL.png",
		"dicas": [
			"ORDER BY organiza os resultados por uma coluna específica",
			"DESC significa decrescente (maior para menor). ASC seria crescente",
			"A estrutura é: SELECT colunas FROM tabela ORDER BY coluna DESC"
		],
		"proximo_caso": 6
	},
	6: {
		"titulo": "Caso 06: Investigando a Suspeita",
		"descricao": "Delegado Turing: Detetive, estou desconfiado da Sofia Alves. Ela é Desenvolvedora Sênior, tem ACESSO TOTAL ao sistema e conhecimento técnico para executar o ataque. Preciso que você investigue o comportamento dela.\n\nNa tabela 'Transferencias_Arquivos', mostre TODAS as transferências da Sofia (id_funcionario_acao = 'SOFIA_SR') nos dias 2025-10-20 OU 2025-10-21. Use OR entre as datas e PARÊNTESES para agrupar. Preciso de FATOS, não suposições.",
		"blocos_disponiveis": [")", "'%2025-10-21%'", "LIKE", "timestamp_transferencia", "OR", "'%2025-10-20%'", "(", "AND", "'SOFIA_SR'", "=", "id_funcionario_acao", "WHERE", "Transferencias_Arquivos", "FROM", "*", "SELECT", "LIKE", "timestamp_transferencia"],
		"resposta_correta": ["SELECT", "*", "FROM", "Transferencias_Arquivos", "WHERE", "id_funcionario_acao", "=", "'SOFIA_SR'", "AND", "(", "timestamp_transferencia", "LIKE", "'%2025-10-20%'", "OR", "timestamp_transferencia", "LIKE", "'%2025-10-21%'", ")"],
		"mensagem_sucesso": "Delegado, os dados são claros: Sofia fez apenas backups de rotina às 00:30 do dia 21, ANTES do ataque às 02:14. Comportamento totalmente normal, procedimento padrão de segurança. Ela é INOCENTE. Com todo respeito, senhor, precisamos focar em suspeitos reais, não em profissionais dedicados.",
		"imagem": "res://assets/imagens/Delegado_Turing_SQL.png",
		"dicas": [
			"Use OR quando quer que PELO MENOS UMA condição seja verdadeira",
			"Use parênteses ( ) para agrupar condições OR quando combinar com AND",
			"SELECT * retorna TODAS as colunas da tabela"
		],
		"proximo_caso": 7
	},
	7: {
		"titulo": "Caso 07: Entendendo Conexões",
		"descricao": "Ada: Sofia foi descartada. Agora, antes de mergulharmos em análises mais complexas, você precisa entender um conceito FUNDAMENTAL: tabelas RELACIONADAS. Os dados estão espalhados em várias tabelas conectadas por IDs.\n\nVamos verificar a alocação oficial do Projeto Nexus. Na tabela 'Alocacao_Projeto', mostre ID_PROJETO, ID_FUNCIONARIO e PAPEL de funcionários no 'PROJ-001'. ORDENE alfabeticamente por id_funcionario. Isso vai revelar quem tinha acesso oficial ao projeto!",
		"blocos_disponiveis": ["DESC", "ASC", "id_funcionario", "ORDER BY", "'PROJ-001'", "=", "id_projeto", "WHERE", "Alocacao_Projeto", "FROM", "horas_semanais", "papel", ",", "id_funcionario", ",", "id_projeto", "SELECT"],
		"resposta_correta": ["SELECT", "id_projeto", ",", "id_funcionario", ",", "papel", "FROM", "Alocacao_Projeto", "WHERE", "id_projeto", "=", "'PROJ-001'", "ORDER BY", "id_funcionario"],
		"mensagem_sucesso": "Perfeito! Veja os IDs: CARLOS_JR, E-774, INF-602, PEDRO_QA, SOFIA_SR. Esses são CÓDIGOS que se conectam à tabela 'Funcionarios'! E-774 está na lista oficial... mas você notou algo? Esse ID é diferente do padrão dos outros. Isso vai ser importante em breve!",
		"imagem": "res://assets/imagens/Ada_Lovelace_SQL.png",
		"dicas": [
			"IDs são como 'chaves' que conectam informações entre tabelas diferentes",
			"ORDER BY sem ASC ou DESC usa ordem crescente (alfabética) como padrão",
			"Este exercício prepara você para entender JOINs no próximo caso"
		],
		"proximo_caso": 8
	},
	8: {
		"titulo": "Caso 08: Ordenando a Timeline",
		"descricao": "Ada: Ana Luíza conseguiu descriptografar o arquivo 'x0A_1g_k3.log'! Ele contém registros de logins durante a madrugada. Preciso reconstruir a TIMELINE EXATA dos eventos.\n\nNa tabela 'Logs_Acesso_Sistema', busque logins entre 00h-02h (horas 0, 1 e 2) do dia 2025-10-21. Use OR para combinar as 3 horas. Depois ORDENE por timestamp_login e mostre apenas os 5 PRIMEIROS (LIMIT 5). Quero id_funcionario e timestamp_login.",
		"blocos_disponiveis": ["5", "LIMIT", "timestamp_login", "ORDER BY", ")", "(", "AND", "'%2025-10-21 2%'", "'%2025-10-21 1%'", "LIKE", "OR", "'%2025-10-21 0%'", "timestamp_login", "WHERE", "Logs_Acesso_Sistema", "FROM", "timestamp_login", ",", "id_funcionario", "SELECT", "LIKE", "timestamp_login", "OR", "LIKE", "timestamp_login"],
		"resposta_correta": ["SELECT", "id_funcionario", ",", "timestamp_login", "FROM", "Logs_Acesso_Sistema", "WHERE", "timestamp_login", "LIKE", "'%2025-10-21 0%'", "OR", "timestamp_login", "LIKE", "'%2025-10-21 1%'", "OR", "timestamp_login", "LIKE", "'%2025-10-21 2%'", "ORDER BY", "timestamp_login", "LIMIT", "5"],
		"mensagem_sucesso": "TIMELINE RECONSTRUÍDA! Cinco logins cronológicos: Sofia (00:10:15 - backup), Pedro (01:05:42 - teste noturno), Carlos (01:50:32 - atividade suspeita!), Marcos (02:13:21) e... ESPERA. 'E-774' às 02:14:05?! ID não identificado! Quem diabos é E-774?!",
		"imagem": "res://assets/imagens/Ada_Lovelace_SQL.png",
		"dicas": [
			"ORDER BY ordena os resultados por uma coluna específica",
			"LIMIT restringe quantas linhas serão retornadas",
			"Múltiplas condições OR precisam estar conectadas (OR entre cada LIKE)"
		],
		"proximo_caso": 9
	},
	9: {
		"titulo": "Caso 09: Quem Criou o Arquivo?",
		"descricao": "Ana Luíza: Ada! Terminei a análise forense do arquivo 'x0A_1g_k3.log' e descobri algo CRUCIAL! Esse arquivo NÃO foi criado pelo invasor - foi criado por alguém tentando DEFENDER o sistema!\n\nPreciso que você descubra quem é nosso herói. Aqui vai seu primeiro JOIN - conectar duas tabelas. Una 'Funcionarios' (alias 'f') com 'Arquivos_Servidor' (alias 'a') usando f.id_funcionario = a.id_criador. Filtre WHERE o arquivo é 'x0A_1g_k3.log'. Mostre o nome_completo.",
		"blocos_disponiveis": ["'x0A_1g_k3.log'", "=", "a.nome_arquivo", "WHERE", "a.id_criador", "=", "f.id_funcionario", "ON", "a", "Arquivos_Servidor", "JOIN", "f", "Funcionarios", "FROM", "a.nome_arquivo", ",", "f.nome_completo", "SELECT"],
		"resposta_correta": ["SELECT", "f.nome_completo", "FROM", "Funcionarios", "f", "JOIN", "Arquivos_Servidor", "a", "ON", "f.id_funcionario", "=", "a.id_criador", "WHERE", "a.nome_arquivo", "=", "'x0A_1g_k3.log'"],
		"mensagem_sucesso": "Ana Luíza: CARLOS SILVA! O Programador Júnior! Exatamente o que suspeitei! Pelos timestamps do arquivo, ele detectou o invasor às 01:50 e criou esse log de emergência para registrar a atividade maliciosa. Ele NÃO é o invasor... ele é o HERÓI que tentou defender o sistema! Mas foi derrubado pelo atacante. Precisamos honrá-lo, Ada.",
		"imagem": "res://assets/imagens/Ana_Luiza_SQL.png",
		"dicas": [
			"JOIN conecta duas tabelas através de uma coluna comum",
			"Use alias (f, a) para abreviar nomes de tabelas",
			"A estrutura é: SELECT ... FROM tabela1 alias JOIN tabela2 alias ON ligação"
		],
		"proximo_caso": 10
	},
	10: {
		"titulo": "Caso 10: A Janela de Oportunidade",
		"descricao": "Ada: Vamos reduzir ainda mais o cerco! Quem do departamento 'Desenvolvimento' estava logado entre 00h-02h? CUIDADO: pessoas fazem múltiplos logins. Precisamos de NOMES ÚNICOS.\n\nUse JOIN entre 'Funcionarios' (f) e 'Logs_Acesso_Sistema' (l) através de id_funcionario. Filtre WHERE: departamento = 'Desenvolvimento' E timestamps das horas 0, 1 OU 2. Use SELECT DISTINCT para eliminar duplicatas e mostrar apenas nomes únicos.",
		"blocos_disponiveis": [")", "'%2025-10-21 2%'", "'%2025-10-21 1%'", "LIKE", "l.timestamp_login", "OR", "'%2025-10-21 0%'", "(", "AND", "'Desenvolvimento'", "=", "f.departamento", "WHERE", "l.id_funcionario", "=", "f.id_funcionario", "ON", "l", "Logs_Acesso_Sistema", "JOIN", "f", "Funcionarios", "FROM", "l.timestamp_login", ",", "f.nome_completo", "DISTINCT", "SELECT", "OR", "LIKE", "l.timestamp_login", "LIKE"],
		"resposta_correta": ["SELECT", "DISTINCT", "f.nome_completo", "FROM", "Funcionarios", "f", "JOIN", "Logs_Acesso_Sistema", "l", "ON", "f.id_funcionario", "=", "l.id_funcionario", "WHERE", "f.departamento", "=", "'Desenvolvimento'", "AND", "(", "l.timestamp_login", "LIKE", "'%2025-10-21 0%'", "OR", "l.timestamp_login", "LIKE", "'%2025-10-21 1%'", "OR", "l.timestamp_login", "LIKE", "'%2025-10-21 2%'", ")"],
		"mensagem_sucesso": "Três nomes ÚNICOS do Desenvolvimento online na madrugada: Sofia Alves (já descartada - inocente), Pedro Martins e Carlos Silva (herói que defendeu o sistema). Espera... cadê o QUARTO nome? Quem é E-774?! Esse ID não está no departamento de Desenvolvimento!",
		"imagem": "res://assets/imagens/Ada_Lovelace_SQL.png",
		"dicas": [
			"DISTINCT remove valores duplicados do resultado",
			"Combine JOIN com WHERE para filtrar dados de tabelas conectadas",
			"Use parênteses para agrupar múltiplas condições OR depois de AND",
			"SELECT DISTINCT vai no início da query, logo após SELECT",
			"Complete todas as 3 condições de horário: '%...0%' OR '%...1%' OR '%...2%'"
		],
		"proximo_caso": 11
	},
	11: {
		"titulo": "Caso 11: Comportamento Suspeito",
		"descricao": "Delegado Turing: Detetive! Ana Luíza encontrou algo CRÍTICO no arquivo do Carlos. Antes de ser derrubado, ele registrou o ID do invasor: 'E-774'. Preciso que você identifique QUEM é essa pessoa IMEDIATAMENTE.\n\nBusque na tabela 'Funcionarios' quem tem id_funcionario = 'E-774'. Mostre NOME COMPLETO e CARGO. Se for quem estou pensando, temos um problema GRAVE de segurança nacional. Execute a consulta AGORA!",
		"blocos_disponiveis": ["'E-774'", "=", "id_funcionario", "WHERE", "Funcionarios", "FROM", "id_funcionario", "cargo", ",", "nome_completo", "SELECT"],
		"resposta_correta": ["SELECT", "nome_completo", ",", "cargo", "FROM", "Funcionarios", "WHERE", "id_funcionario", "=", "'E-774'"],
		"mensagem_sucesso": "Delegado Turing: MARCOS OLIVEIRA?! O DIRETOR DE OPERAÇÕES DA DATACORP?! Isso é GRAVÍSSIMO! Ele tem acesso TOTAL aos sistemas, conhece TODOS os protocolos de segurança... Mas não posso prender um diretor sem PROVA FÍSICA IRREFUTÁVEL. Detetive, preciso de EVIDÊNCIA CONCRETA do crime!",
		"imagem": "res://assets/imagens/Delegado_Turing_SQL.png",
		"dicas": [
			"Use WHERE com = para buscar valores exatos",
			"IDs geralmente precisam estar entre aspas simples",
			"SELECT permite escolher quais colunas mostrar",
			"Esta é uma query simples: SELECT colunas FROM tabela WHERE id = 'valor'",
			"Não esqueça de colocar 'E-774' entre aspas simples"
		],
		"proximo_caso": 12
	},
	12: {
		"titulo": "Caso 12: A Prova Definitiva",
		"descricao": "Ada: Esta é a ÚLTIMA JOGADA, Delegado Turing! Vamos provar que Marcos ROUBOU credenciais do Carlos para fazer o ataque. Prepare-se para o query SQL mais complexo da investigação!\n\nVocê vai fazer JOIN TRIPLO conectando 3 tabelas: Funcionarios (f) → Transferencias_Arquivos (t) → Arquivos_Servidor (a). Busque transferências 'Externa' onde a pessoa que fez (id_funcionario_acao) é DIFERENTE da credencial usada (id_credencial_usada). Use != para 'diferente'. Mostre: nome, arquivo e credencial_usada.",
		"blocos_disponiveis": ["t.id_credencial_usada", "!=", "t.id_funcionario_acao", "AND", "'Externa'", "=", "t.tipo_transferencia", "WHERE", "t.id_arquivo", "=", "a.id_arquivo", "ON", "a", "Arquivos_Servidor", "JOIN", "t.id_funcionario_acao", "=", "f.id_funcionario", "ON", "t", "Transferencias_Arquivos", "JOIN", "f", "Funcionarios", "FROM", "t.timestamp_transferencia", "t.id_credencial_usada", ",", "a.nome_arquivo", ",", "f.nome_completo", "SELECT"],
		"resposta_correta": ["SELECT", "f.nome_completo", ",", "a.nome_arquivo", ",", "t.id_credencial_usada", "FROM", "Funcionarios", "f", "JOIN", "Transferencias_Arquivos", "t", "ON", "f.id_funcionario", "=", "t.id_funcionario_acao", "JOIN", "Arquivos_Servidor", "a", "ON", "a.id_arquivo", "=", "t.id_arquivo", "WHERE", "t.tipo_transferencia", "=", "'Externa'", "AND", "t.id_funcionario_acao", "!=", "t.id_credencial_usada"],
		"mensagem_sucesso": "CONSEGUIMOS! PROVA IRREFUTÁVEL: Marcos Oliveira (E-774) transferiu externamente o arquivo 'documento_secreto.pdf' usando as credenciais ROUBADAS do Carlos Silva (CARLOS_JR)! Temos: NOME do criminoso, ARQUIVO vazado, PROVA de roubo de identidade e HORÁRIO exato (02:14h). CASO OFICIALMENTE RESOLVIDO! Carlos Silva é um HERÓI!",
		"imagem": "res://assets/imagens/Ada_Lovelace_SQL.png",
		"dicas": [
			"JOIN triplo conecta 3 tabelas em sequência",
			"Use != para verificar quando dois valores são DIFERENTES",
			"Combine múltiplos JOINs com WHERE para filtros complexos",
			"Primeiro JOIN: f.id_funcionario = t.id_funcionario_acao",
			"Segundo JOIN: a.id_arquivo = t.id_arquivo",
			"A estrutura completa: SELECT ... FROM f JOIN t ON ... JOIN a ON ... WHERE ... AND ...",
			"Você precisa de 2 condições no WHERE: tipo_transferencia = 'Externa' E id_funcionario_acao != id_credencial_usada"
		],
		"proximo_caso": null
	}
}

# --- VARIÁVEIS DO TYPEWRITER DA MISSÃO ---
var missao_texto_completo = ""  # Será preenchida dinamicamente
var missao_caractere_atual = 0
var missao_velocidade_texto = Configuracoes.velocidade_texto # Usa configuração do jogador
var missao_timer = 0.0
var missao_texto_terminou = false

# --- VARIÁVEIS DO SISTEMA DE DICAS ---
var dica_atual = 0  # Índice da próxima dica a ser mostrada
var tentativas_erradas = 0  # Contador de tentativas erradas

# --- FUNÇÕES NÚCLEO (READY, PROCESS, EXIT) ---
func _ready():
	# PROTEÇÃO: NÃO executa código de banco de dados no editor
	if Engine.is_editor_hint():
		print("Modo Editor detectado - inicialização de DB ignorada.")
		return

	if feedback_label:
		feedback_label.visible = false

	# Conecta os botões de categoria
	if btn_todos:
		btn_todos.pressed.connect(_on_categoria_selecionada.bind("todos"))
	if btn_comandos:
		btn_comandos.pressed.connect(_on_categoria_selecionada.bind("comandos"))
	if btn_operadores:
		btn_operadores.pressed.connect(_on_categoria_selecionada.bind("operadores"))
	if btn_dados:
		btn_dados.pressed.connect(_on_categoria_selecionada.bind("dados"))

	# Destaca o botão "Todos" como padrão
	atualizar_visual_botoes_categoria()

	# Adiciona som de hover aos botões de categoria
	adicionar_som_hover_botoes_categoria()

	# Aplica tamanho de fonte das configurações
	aplicar_tamanho_fonte()

	# Inicia a música do jogo
	Configuracoes.tocar_musica_jogo()

	# Carrega o caso inicial
	carregar_caso(caso_atual)

	print("Interface de Casos (Modo Blocos) pronta.")

func adicionar_som_hover_botoes_categoria():
	# Conecta som de hover aos botões de categoria
	if btn_todos:
		btn_todos.mouse_entered.connect(_on_botao_hover)
	if btn_comandos:
		btn_comandos.mouse_entered.connect(_on_botao_hover)
	if btn_operadores:
		btn_operadores.mouse_entered.connect(_on_botao_hover)
	if btn_dados:
		btn_dados.mouse_entered.connect(_on_botao_hover)

func _on_botao_hover():
	Configuracoes.tocar_som_hover()

# --- FUNÇÃO PARA CARREGAR UM CASO ESPECÍFICO ---
func carregar_caso(numero_caso: int):
	if not casos.has(numero_caso):
		printerr("ERRO: Caso ", numero_caso, " não existe!")
		return

	var caso = casos[numero_caso]
	caso_atual = numero_caso

	# Atualiza a velocidade do texto com a configuração atual
	missao_velocidade_texto = Configuracoes.velocidade_texto

	# Reseta o sistema de dicas para o novo caso
	dica_atual = 0
	tentativas_erradas = 0

	# Atualiza o texto da missão com formatação especial
	var titulo_formatado = "═══════════════════════════════════════════════════\n"
	titulo_formatado += "▓▓▓ " + caso["titulo"].to_upper() + " ▓▓▓\n"
	titulo_formatado += "═══════════════════════════════════════════════════\n\n"

	# Destaca o nome do personagem na descrição
	var descricao = caso["descricao"]
	# Detecta e formata nomes dos personagens (Ada, Ana Luíza, Delegado Turing)
	descricao = descricao.replace("Ada:", "ADA LOVELACE:")
	descricao = descricao.replace("Ana Luíza:", "ANA LUÍZA:")
	descricao = descricao.replace("Delegado Turing:", "DELEGADO TURING:")

	missao_texto_completo = titulo_formatado + descricao

	# Atualiza os blocos disponíveis
	atualizar_blocos_disponiveis(caso["blocos_disponiveis"])

	# Esconde o feedback_label e garante que missao_label esteja visível
	if feedback_label:
		feedback_label.visible = false

	# Inicia o efeito typewriter
	if missao_label:
		var texto_limpo = missao_texto_completo.strip_edges(true, true)
		missao_label.text = texto_limpo
		missao_label.visible_characters = 0
		missao_label.visible = true
		missao_label.remove_theme_color_override("font_color") # Remove qualquer cor customizada
		missao_caractere_atual = 0
		missao_texto_terminou = false
		set_process(true)
	else:
		printerr("ERRO: Nó 'missao_label' não encontrado!")

	# Limpa a área de montagem
	if area_montagem:
		for child in area_montagem.get_children():
			child.queue_free()

	# Troca a imagem do personagem (se especificado no caso)
	var texture_rect = $Painel_Missao/Divisor_missao/TextureRect
	if texture_rect and caso.has("imagem"):
		var nova_imagem = load(caso["imagem"])
		if nova_imagem:
			texture_rect.texture = nova_imagem
			imagem_atual = caso["imagem"]
			print("Imagem trocada para: ", caso["imagem"])
		else:
			printerr("ERRO: Não foi possível carregar a imagem: ", caso["imagem"])

	# Cria botões de ajuda apenas se modo aprendizado estiver ativo
	if Configuracoes.modo_aprendizado:
		# Cria o botão de dica (se o caso tiver dicas)
		if caso.has("dicas") and caso["dicas"].size() > 0:
			criar_botao_dica()

		# Cria o botão de Ajuda SQL (sempre disponível em modo aprendizado)
		criar_botao_ajuda_sql()
	else:
		print("Modo aprendizado desativado - botões de ajuda não criados")

	print("Caso ", numero_caso, " carregado: ", caso["titulo"])

# --- FUNÇÃO PARA ATUALIZAR BLOCOS DISPONÍVEIS ---
func atualizar_blocos_disponiveis(blocos: Array):
	# Remove duplicatas mantendo a ordem
	var blocos_unicos = []
	for bloco in blocos:
		if bloco not in blocos_unicos:
			blocos_unicos.append(bloco)

	# Salva todos os blocos disponíveis para o caso atual
	blocos_disponiveis_completos = blocos_unicos

	# Reseta a categoria para "todos" ao carregar um novo caso
	categoria_atual = "todos"
	atualizar_visual_botoes_categoria()

	# Renderiza os blocos
	renderizar_blocos()

# --- FUNÇÃO PARA RENDERIZAR BLOCOS BASEADO NA CATEGORIA ---
func renderizar_blocos():
	var container_blocos = $Painel_Console/VBox_Blocos/ScrollContainer_Blocos/Blocos_Disponiveis
	if not container_blocos:
		printerr("ERRO: Container de blocos não encontrado!")
		return

	# Remove blocos antigos
	for child in container_blocos.get_children():
		child.queue_free()

	# Aguarda um frame para garantir que os nós foram removidos
	await get_tree().process_frame

	# Define comandos SQL (azul) vs dados (verde)
	var comandos_sql = ["SELECT", "FROM", "WHERE", "JOIN", "ON", "AND", "OR", "LIKE", "DISTINCT", "!=", "="]
	var operadores = [",", "(", ")", "*"]

	# Filtra blocos baseado na categoria selecionada
	var blocos_filtrados = []
	for bloco_texto in blocos_disponiveis_completos:
		if categoria_atual == "todos":
			blocos_filtrados.append(bloco_texto)
		elif categoria_atual == "comandos" and bloco_texto in comandos_sql:
			blocos_filtrados.append(bloco_texto)
		elif categoria_atual == "operadores" and bloco_texto in operadores:
			blocos_filtrados.append(bloco_texto)
		elif categoria_atual == "dados" and bloco_texto not in comandos_sql and bloco_texto not in operadores:
			blocos_filtrados.append(bloco_texto)

	# Cria novos blocos
	for bloco_texto in blocos_filtrados:
		var botao = Button.new()
		botao.text = bloco_texto
		botao.custom_minimum_size = Vector2(80, 35)  # Tamanho mínimo para evitar colagem

		# Estiliza de acordo com o tipo de bloco
		var style_normal = StyleBoxFlat.new()
		style_normal.corner_radius_top_left = 5
		style_normal.corner_radius_top_right = 5
		style_normal.corner_radius_bottom_left = 5
		style_normal.corner_radius_bottom_right = 5

		# Adiciona padding interno para afastar o texto das bordas
		style_normal.content_margin_left = 8
		style_normal.content_margin_right = 8
		style_normal.content_margin_top = 6
		style_normal.content_margin_bottom = 6

		if bloco_texto in comandos_sql:
			# Comandos SQL - Azul
			style_normal.bg_color = Color(0.2, 0.4, 0.8, 1.0)  # Azul
			botao.add_theme_color_override("font_color", Color.WHITE)
		elif bloco_texto in operadores:
			# Operadores - Roxo
			style_normal.bg_color = Color(0.6, 0.3, 0.8, 1.0)  # Roxo
			botao.add_theme_color_override("font_color", Color.WHITE)
		else:
			# Dados (tabelas, colunas, valores) - Verde
			style_normal.bg_color = Color(0.2, 0.7, 0.3, 1.0)  # Verde
			botao.add_theme_color_override("font_color", Color.WHITE)

		botao.add_theme_stylebox_override("normal", style_normal)

		var style_hover = StyleBoxFlat.new()
		style_hover.bg_color = style_normal.bg_color.lightened(0.2)  # 20% mais claro no hover
		style_hover.corner_radius_top_left = 5
		style_hover.corner_radius_top_right = 5
		style_hover.corner_radius_bottom_left = 5
		style_hover.corner_radius_bottom_right = 5
		# Mantém o mesmo padding do estado normal
		style_hover.content_margin_left = 8
		style_hover.content_margin_right = 8
		style_hover.content_margin_top = 6
		style_hover.content_margin_bottom = 6
		botao.add_theme_stylebox_override("hover", style_hover)

		# Adiciona o script de arrastar
		var script_path = "res://bloco_arrastavel.gd"
		botao.set_script(load(script_path))

		container_blocos.add_child(botao)

# --- FUNÇÃO _process PARA O TYPEWRITER ---
func _process(delta):
	if missao_texto_terminou:
		set_process(false)
		return
	missao_timer += delta
	var total_caracteres = missao_label.get_total_character_count()
	if missao_timer >= missao_velocidade_texto and missao_caractere_atual < total_caracteres:
		missao_timer = 0
		missao_caractere_atual += 1
		missao_label.visible_characters = missao_caractere_atual
	if missao_caractere_atual >= total_caracteres:
		missao_texto_terminou = true

# --- FUNÇÃO _input PARA ACELERAR O TEXTO DA MISSÃO ---
func _input(event):
	# Verifica se foi pressionada a tecla Enter OU qualquer botão do mouse
	var input_pressionado = event.is_action_pressed("ui_accept") or \
						   (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed)

	if input_pressionado:
		if not missao_texto_terminou:
			# Se o texto AINDA NÃO terminou, acelera!
			print("Acelerando texto da missão...")
			missao_caractere_atual = missao_label.get_total_character_count() # Vai para o fim
			missao_label.visible_characters = -1 # Revela tudo (-1 mostra todos)
			missao_texto_terminou = true # Marca que terminou
			set_process(false) # Para o _process

# --- Garante fechamento do DB ---
func _exit_tree():
	if db:
		db.close_db()
		print("Banco de dados fechado.")

# --- FUNÇÃO PRINCIPAL DO BOTÃO ---
# --- FUNÇÃO PARA LIMPAR ÁREA DE MONTAGEM ---
func _on_btn_limpar_pressed():
	if area_montagem:
		# Remove todos os blocos da área de montagem
		for bloco_node in area_montagem.get_children():
			bloco_node.queue_free()
		print("Área de montagem limpa!")
	else:
		printerr("ERRO: Área de montagem não encontrada!")

func _on_button_pressed():
	# LAZY LOADING: Instancia e abre o DB apenas na primeira execução
	if not db_aberto:
		# Instancia SQLite APENAS quando necessário
		db = SQLite.new()
		
		# --- ALTERAÇÃO AQUI: Em vez de usar "res://", chamamos a função de cópia ---
		var db_path = verificar_e_copiar_banco() 
		# -----------------------------------------------------------------------
		
		db.path = db_path
		if db.open_db():
			print("Banco de dados aberto com sucesso em: ", db_path)
			db_aberto = true
		else:
			printerr("ERRO CRÍTICO: Não foi possível abrir o banco de dados!")
			exibir_mensagem_falha("Erro ao conectar ao banco de dados.")
			return

	limpar_resultados()
	var sequencia_jogador = []
	if area_montagem:
		for bloco_node in area_montagem.get_children():
			if bloco_node is Label:
				sequencia_jogador.append(bloco_node.text)
	else:
		exibir_mensagem_falha("Erro interno: Área de montagem não encontrada.")
		return

	# Pega a resposta correta do caso atual
	var caso = casos[caso_atual]
	var resposta_correta = caso["resposta_correta"]

	var blocos_corretos = (sequencia_jogador == resposta_correta)
	if not blocos_corretos:
		exibir_mensagem_falha(sequencia_jogador)
		return

	var query_sql = " ".join(sequencia_jogador)
	var sucesso_query = db.query(query_sql)
	if sucesso_query:
		var resultado_db = db.query_result
		exibir_resultados_reais(resultado_db)
		exibir_mensagem_sucesso_com_proximo_caso()
	else:
		printerr("ERRO ao executar a query no banco: ", query_sql)
		exibir_mensagem_falha("Erro de Sintaxe SQL!\nDica: A consulta montada não é válida. Verifique se:\n- Os nomes de colunas e tabelas estão corretos\n- Os operadores estão nos lugares certos (=, LIKE, etc.)\n- As aspas estão fechadas corretamente\n- Não há blocos duplicados ou faltando")

# --- NOVA FUNÇÃO PARA CORRIGIR O ERRO DE EXPORTAÇÃO ---
func verificar_e_copiar_banco() -> String:
	var path_origem = "res://casos.db"    # Onde o arquivo está no projeto
	var path_destino = "user://casos.db"  # Onde ele vai ficar no PC do jogador
	
	# Cria um objeto de acesso a diretório
	var dir = DirAccess.open("user://")
	
	# Verifica se o arquivo JÁ existe na pasta do usuário
	if not FileAccess.file_exists(path_destino):
		print("Detectado primeira execução ou banco ausente.")
		print("Copiando de '", path_origem, "' para '", path_destino, "'...")
		
		# Precisamos de acesso de leitura ao sistema de arquivos 'res://'
		var dir_res = DirAccess.open("res://")
		var erro = dir_res.copy(path_origem, path_destino)
		
		if erro == OK:
			print("Banco de dados copiado com sucesso!")
		else:
			printerr("ERRO AO COPIAR BANCO DE DADOS! Código de erro: ", erro)
	else:
		print("Banco de dados já existe em user://. Usando arquivo existente.")
		
	return path_destino

# --- FUNÇÕES AJUDANTES (LIMPAR, RESULTADOS) ---
func limpar_resultados():
	for n in grid_resultados.get_children():
		n.queue_free()
	if feedback_label:
		feedback_label.visible = false
		feedback_label.text = ""

func exibir_resultados_reais(dados):
	# Verifica se deve mostrar resultados SQL
	if not Configuracoes.mostrar_resultados_sql:
		print("Resultados SQL ocultados pela configuração do jogador")
		return

	if not grid_resultados:
		printerr("ERRO: Nó 'grid_resultados' não encontrado!")
		return

	# Adiciona espaçamento entre colunas do GridContainer
	grid_resultados.add_theme_constant_override("h_separation", 20)  # Espaço horizontal entre colunas
	grid_resultados.add_theme_constant_override("v_separation", 8)   # Espaço vertical entre linhas

	if dados.size() == 0:
		grid_resultados.columns = 1
		var celula_vazia = Label.new()
		celula_vazia.text = "Nenhum resultado encontrado."
		grid_resultados.add_child(celula_vazia)
		return

	var colunas_nomes = dados[0].keys()
	grid_resultados.columns = colunas_nomes.size()

	# Cabeçalhos com padding e fundo
	for nome_coluna in colunas_nomes:
		var cabecalho_container = PanelContainer.new()
		cabecalho_container.custom_minimum_size = Vector2(150, 0)  # Largura mínima para legibilidade

		# Estilo do painel do cabeçalho
		var style_cabecalho = StyleBoxFlat.new()
		style_cabecalho.bg_color = Color(0.2, 0.2, 0.25, 1)  # Fundo escuro
		style_cabecalho.content_margin_left = 12
		style_cabecalho.content_margin_right = 12
		style_cabecalho.content_margin_top = 8
		style_cabecalho.content_margin_bottom = 8
		style_cabecalho.corner_radius_top_left = 4
		style_cabecalho.corner_radius_top_right = 4
		style_cabecalho.corner_radius_bottom_left = 4
		style_cabecalho.corner_radius_bottom_right = 4
		cabecalho_container.add_theme_stylebox_override("panel", style_cabecalho)

		var cabecalho = Label.new()
		cabecalho.text = nome_coluna.capitalize()
		cabecalho.add_theme_font_size_override("font_size", 18)
		cabecalho.add_theme_color_override("font_color", Color.YELLOW)
		cabecalho.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		cabecalho.custom_minimum_size = Vector2(120, 0)  # Garante largura mínima
		cabecalho_container.add_child(cabecalho)
		grid_resultados.add_child(cabecalho_container)

	# Células de dados com padding
	for linha in dados:
		for nome_coluna in colunas_nomes:
			var celula_container = PanelContainer.new()
			celula_container.custom_minimum_size = Vector2(150, 0)  # Largura mínima

			# Estilo do painel da célula
			var style_celula = StyleBoxFlat.new()
			style_celula.bg_color = Color(0.15, 0.15, 0.18, 0.5)  # Fundo semi-transparente
			style_celula.content_margin_left = 12
			style_celula.content_margin_right = 12
			style_celula.content_margin_top = 6
			style_celula.content_margin_bottom = 6
			style_celula.corner_radius_top_left = 3
			style_celula.corner_radius_top_right = 3
			style_celula.corner_radius_bottom_left = 3
			style_celula.corner_radius_bottom_right = 3
			celula_container.add_theme_stylebox_override("panel", style_celula)

			var celula = Label.new()
			var valor = linha[nome_coluna]
			celula.text = str(valor) if valor != null else "NULL"
			celula.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART  # Quebra de linha automática
			celula.custom_minimum_size = Vector2(120, 0)  # Garante largura mínima
			celula.clip_text = false  # Permite texto crescer verticalmente
			celula_container.add_child(celula)
			grid_resultados.add_child(celula_container)

# --- FUNÇÕES DE FEEDBACK (SUCESSO E FALHA COM DICAS) ---
func exibir_mensagem_sucesso_com_proximo_caso():
	if missao_label:
		var caso = casos[caso_atual]
		var proximo = caso.get("proximo_caso", null)

		# Usa mensagem customizada do caso ou mensagem padrão
		var mensagem_custom = caso.get("mensagem_sucesso", "")

		# Para o efeito typewriter e mostra o desfecho no lugar da missão
		missao_texto_terminou = true
		set_process(false)

		if proximo and casos.has(proximo):
			if mensagem_custom != "":
				missao_label.text = mensagem_custom + "\n\n[Pressione 'Próximo Caso' para continuar]"
			else:
				missao_label.text = "Caso Resolvido! Pressione 'Próximo Caso' para continuar a investigação."
			# Cria botão para próximo caso
			criar_botao_proximo_caso(proximo)
		else:
			if mensagem_custom != "":
				missao_label.text = mensagem_custom + "\n\n[Pressione 'Finalizar Jogo' para ver a conclusão]"
			else:
				missao_label.text = "Caso Resolvido! Pressione 'Finalizar Jogo' para ver a conclusão!"
			# Cria botão para finalizar o jogo
			criar_botao_finalizar_jogo()

		# Remove a cor verde - usa a cor padrão do texto
		missao_label.remove_theme_color_override("font_color")
		missao_label.visible_characters = -1 # Mostra tudo de uma vez
		missao_label.visible = true

		# Esconde o feedback_label
		if feedback_label:
			feedback_label.visible = false
	else:
		printerr("ERRO: Referência 'missao_label' é inválida ao tentar exibir sucesso!")

func criar_botao_proximo_caso(numero_proximo_caso: int):
	# Verifica se já existe um botão
	var painel_console = $Painel_Console
	var botao_existente = painel_console.get_node_or_null("BotaoProximoCaso")
	if botao_existente:
		botao_existente.queue_free()

	# Cria novo botão GRANDE e CHAMATIVO no Painel_Console (acima dos botões de ajuda)
	var botao = Button.new()
	botao.name = "BotaoProximoCaso"
	botao.text = "▶▶ PRÓXIMO CASO ▶▶"
	botao.position = Vector2(160, 780)  # Centralizado acima dos botões de dica/SQL
	botao.custom_minimum_size = Vector2(320, 60)  # Largo e visível
	botao.add_theme_font_size_override("font_size", 26)  # Fonte grande

	# Cor verde chamativa para indicar sucesso
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = Color(0.2, 0.7, 0.2, 1.0)  # Verde
	style_normal.corner_radius_top_left = 10
	style_normal.corner_radius_top_right = 10
	style_normal.corner_radius_bottom_left = 10
	style_normal.corner_radius_bottom_right = 10
	botao.add_theme_stylebox_override("normal", style_normal)

	var style_hover = StyleBoxFlat.new()
	style_hover.bg_color = Color(0.3, 0.9, 0.3, 1.0)  # Verde mais claro ao passar mouse
	style_hover.corner_radius_top_left = 10
	style_hover.corner_radius_top_right = 10
	style_hover.corner_radius_bottom_left = 10
	style_hover.corner_radius_bottom_right = 10
	botao.add_theme_stylebox_override("hover", style_hover)

	# Conecta o sinal
	botao.pressed.connect(func(): avancar_para_caso(numero_proximo_caso))

	# Adiciona som de hover
	botao.mouse_entered.connect(_on_botao_hover)

	painel_console.add_child(botao)

func criar_botao_finalizar_jogo():
	# Verifica se já existe um botão
	var painel_console = $Painel_Console
	var botao_existente = painel_console.get_node_or_null("BotaoProximoCaso")
	if botao_existente:
		botao_existente.queue_free()

	# Cria novo botão GRANDE e CHAMATIVO para finalizar o jogo
	var botao = Button.new()
	botao.name = "BotaoProximoCaso"  # Mesmo nome para facilitar remoção
	botao.text = "🎉 FINALIZAR JOGO 🎉"
	botao.position = Vector2(160, 780)  # Centralizado acima dos botões de dica/SQL
	botao.custom_minimum_size = Vector2(320, 60)  # Largo e visível
	botao.add_theme_font_size_override("font_size", 26)  # Fonte grande

	# Cor dourada/amarela chamativa para indicar conclusão
	var style_normal = StyleBoxFlat.new()
	style_normal.bg_color = Color(0.8, 0.6, 0.1, 1.0)  # Dourado
	style_normal.corner_radius_top_left = 10
	style_normal.corner_radius_top_right = 10
	style_normal.corner_radius_bottom_left = 10
	style_normal.corner_radius_bottom_right = 10
	botao.add_theme_stylebox_override("normal", style_normal)

	var style_hover = StyleBoxFlat.new()
	style_hover.bg_color = Color(1.0, 0.8, 0.2, 1.0)  # Dourado mais claro ao passar mouse
	style_hover.corner_radius_top_left = 10
	style_hover.corner_radius_top_right = 10
	style_hover.corner_radius_bottom_left = 10
	style_hover.corner_radius_bottom_right = 10
	botao.add_theme_stylebox_override("hover", style_hover)

	# Conecta o sinal para ir para a tela final
	botao.pressed.connect(func(): GerenciadorCenas.trocar_cena("res://tela_final.tscn"))

	# Adiciona som de hover
	botao.mouse_entered.connect(_on_botao_hover)

	painel_console.add_child(botao)

# --- SISTEMA DE DICAS ---
func criar_botao_dica():
	# Remove botão antigo se existir
	var painel_console = $Painel_Console
	var botao_existente = painel_console.get_node_or_null("BotaoDica")
	if botao_existente:
		botao_existente.queue_free()

	# Cria novo botão de dica no Painel_Console (acima do Executar Query)
	var botao = Button.new()
	botao.name = "BotaoDica"
	botao.text = "💡 Ver Dica"
	botao.position = Vector2(21, 850)  # Acima do Executar Query
	botao.custom_minimum_size = Vector2(290, 50)
	botao.add_theme_font_size_override("font_size", 18)

	# Conecta o sinal
	botao.pressed.connect(mostrar_proxima_dica)

	# Adiciona som de hover
	botao.mouse_entered.connect(_on_botao_hover)

	painel_console.add_child(botao)
	print("Botão de dica criado para o caso ", caso_atual)

func criar_botao_ajuda_sql():
	# Remove botão antigo se existir
	var painel_console = $Painel_Console
	var botao_existente = painel_console.get_node_or_null("BotaoAjudaSQL")
	if botao_existente:
		botao_existente.queue_free()

	# Cria botão de Ajuda SQL no Painel_Console (ao lado do Ver Dica)
	var botao = Button.new()
	botao.name = "BotaoAjudaSQL"
	botao.text = "📚 Ajuda SQL"
	botao.position = Vector2(330, 850)  # Ao lado do botão de dicas
	botao.custom_minimum_size = Vector2(290, 50)
	botao.add_theme_font_size_override("font_size", 18)

	# Conecta o sinal
	botao.pressed.connect(mostrar_ajuda_sql)

	# Adiciona som de hover
	botao.mouse_entered.connect(_on_botao_hover)

	painel_console.add_child(botao)
	print("Botão de Ajuda SQL criado")

func mostrar_proxima_dica():
	var caso = casos[caso_atual]

	if not caso.has("dicas"):
		if feedback_label:
			feedback_label.text = "❌ Não há dicas disponíveis para este caso."
			feedback_label.add_theme_color_override("font_color", Color.ORANGE_RED)
			feedback_label.visible = true
		return

	var dicas = caso["dicas"]

	# Se já mostrou todas as dicas, reinicia do começo
	if dica_atual >= dicas.size():
		dica_atual = 0
		print("Dicas reiniciadas do começo")

	# Mostra a próxima dica
	if feedback_label:
		feedback_label.text = dicas[dica_atual]
		feedback_label.add_theme_color_override("font_color", Color.STEEL_BLUE)
		feedback_label.visible = true

	dica_atual += 1

	print("Dica mostrada: ", dica_atual, "/", dicas.size())

# --- GLOSSÁRIO SQL ---
var glossario_sql = {
	"SELECT": "📌 SELECT: Seleciona quais colunas você quer ver nos resultados.\n\n🔧 COMO USAR:\n1. Comece toda consulta com SELECT\n2. Liste as colunas que deseja ver, separadas por vírgula\n3. Use * para selecionar todas as colunas\n\n✏️ EXEMPLOS:\n• SELECT nome, idade\n• SELECT nome_completo, cargo, departamento\n• SELECT *\n\n💡 DICA: SELECT sempre vem antes de FROM",
	"FROM": "📌 FROM: Indica de qual tabela você quer buscar os dados.\n\n🔧 COMO USAR:\n1. Coloque FROM depois de SELECT\n2. Escreva o nome da tabela ou view\n3. Pode usar alias (apelido) após o nome\n\n✏️ EXEMPLOS:\n• FROM Funcionarios\n• FROM View_Funcionarios_Nexus\n• FROM Funcionarios f (com alias)\n\n💡 DICA: Toda consulta precisa de FROM para indicar a fonte dos dados",
	"WHERE": "📌 WHERE: Filtra os resultados com base em condições.\n\n🔧 COMO USAR:\n1. Coloque WHERE depois de FROM\n2. Escreva a condição de filtro\n3. Combine múltiplas condições com AND/OR\n\n✏️ EXEMPLOS:\n• WHERE idade > 18\n• WHERE departamento = 'Desenvolvimento'\n• WHERE cargo = 'Programador' AND idade > 25\n\n💡 DICA: WHERE é opcional, mas muito útil para filtrar dados específicos",
	"JOIN": "📌 JOIN: Combina dados de duas ou mais tabelas relacionadas.\n\n🔧 COMO USAR:\n1. Coloque JOIN depois de FROM\n2. Escreva o nome da segunda tabela\n3. Use ON para definir como as tabelas se conectam\n\n✏️ EXEMPLOS:\n• FROM Funcionarios f JOIN Projetos p ON f.id = p.id_funcionario\n• JOIN Arquivos_Servidor a ON a.id_criador = f.id_funcionario\n\n💡 DICA: Você pode fazer múltiplos JOINs (JOIN duplo, triplo...)",
	"ON": "📌 ON: Define a condição de relacionamento entre tabelas em um JOIN.\n\n🔧 COMO USAR:\n1. Coloque ON logo após JOIN\n2. Especifique qual coluna de cada tabela deve ser igual\n3. Use aliases para clareza (f.id = a.id_criador)\n\n✏️ EXEMPLOS:\n• ON Funcionarios.id = Projetos.id_funcionario\n• ON f.id_funcionario = l.id_funcionario\n• ON a.id_arquivo = t.id_arquivo\n\n💡 DICA: ON conecta as tabelas pela coluna que elas têm em comum",
	"AND": "📌 AND: Operador lógico que exige que AMBAS as condições sejam verdadeiras.\n\n🔧 COMO USAR:\n1. Use entre duas condições no WHERE\n2. TODAS as condições devem ser verdadeiras\n3. Pode combinar múltiplos ANDs\n\n✏️ EXEMPLOS:\n• WHERE idade > 18 AND cidade = 'SP'\n• WHERE departamento = 'TI' AND cargo = 'Programador'\n• WHERE status = 'Ativo' AND salario > 5000\n\n💡 DICA: AND é restritivo - quanto mais ANDs, MENOS resultados você terá",
	"OR": "📌 OR: Operador lógico onde PELO MENOS UMA condição deve ser verdadeira.\n\n🔧 COMO USAR:\n1. Use entre duas condições no WHERE\n2. QUALQUER condição pode ser verdadeira\n3. Use parênteses ao combinar com AND\n\n✏️ EXEMPLOS:\n• WHERE cidade = 'SP' OR cidade = 'RJ'\n• WHERE cargo = 'Gerente' OR cargo = 'Diretor'\n• WHERE (status = 'A' OR status = 'B') AND idade > 18\n\n💡 DICA: OR é inclusivo - quanto mais ORs, MAIS resultados você terá",
	"LIKE": "📌 LIKE: Busca padrões de texto usando % (qualquer caractere).\n\n🔧 COMO USAR:\n1. Use no WHERE para buscar texto parcial\n2. % no início busca qualquer coisa ANTES\n3. % no fim busca qualquer coisa DEPOIS\n4. % nos dois lados busca em QUALQUER posição\n\n✏️ EXEMPLOS:\n• WHERE nome LIKE '%Silva%' (contém Silva)\n• WHERE arquivo LIKE '%.log' (termina com .log)\n• WHERE data LIKE '%2025-10-21%' (contém essa data)\n\n💡 DICA: % significa 'qualquer texto aqui'",
	"=": "📌 = (igual): Operador de comparação que verifica igualdade exata.\n\n🔧 COMO USAR:\n1. Use para comparar valores exatos\n2. Coloque aspas simples em textos\n3. Não use aspas em números\n\n✏️ EXEMPLOS:\n• WHERE status = 'Ativo'\n• WHERE id_funcionario = 'E-774'\n• WHERE idade = 30\n• WHERE tipo_transferencia = 'Externa'\n\n💡 DICA: Use = para valores exatos, LIKE para padrões",
	"!=": "📌 != (diferente): Operador de comparação que verifica se são diferentes.\n\n🔧 COMO USAR:\n1. Use para encontrar valores que NÃO são iguais\n2. Útil para detectar inconsistências\n3. Funciona com textos e números\n\n✏️ EXEMPLOS:\n• WHERE id_usuario != id_credencial\n• WHERE status != 'Inativo'\n• WHERE id_funcionario_acao != id_credencial_usada\n\n💡 DICA: != é perfeito para encontrar anomalias e fraudes",
	"DISTINCT": "📌 DISTINCT: Remove resultados duplicados, mostrando apenas valores únicos.\n\n🔧 COMO USAR:\n1. Coloque logo após SELECT\n2. Remove linhas repetidas do resultado\n3. Útil quando JOIN cria duplicatas\n\n✏️ EXEMPLOS:\n• SELECT DISTINCT cidade FROM Clientes\n• SELECT DISTINCT nome_completo FROM ...\n• SELECT DISTINCT departamento FROM Funcionarios\n\n💡 DICA: Use quando uma pessoa aparece várias vezes e você quer ver apenas uma vez",
	"*": "📌 * (asterisco): Seleciona TODAS as colunas da tabela.\n\n🔧 COMO USAR:\n1. Use no lugar de listar todas as colunas\n2. Coloque após SELECT\n3. Mostra todas as informações disponíveis\n\n✏️ EXEMPLOS:\n• SELECT * FROM Produtos\n• SELECT * FROM Transferencias_Arquivos\n• SELECT * FROM Funcionarios WHERE cargo = 'Gerente'\n\n💡 DICA: * é rápido, mas liste colunas específicas para mais clareza",
	",": "📌 , (vírgula): Separa múltiplas colunas ou valores.\n\n🔧 COMO USAR:\n1. Use entre nomes de colunas no SELECT\n2. Separa cada coluna que você quer ver\n3. Não coloque vírgula após a última coluna\n\n✏️ EXEMPLOS:\n• SELECT nome, idade, cidade\n• SELECT id_funcionario, nome_completo, cargo, departamento\n• SELECT a.nome_arquivo, t.timestamp_transferencia\n\n💡 DICA: Vírgula ENTRE as colunas, nunca no final",
	"(": "📌 ( (parêntese aberto): Agrupa condições lógicas.\n\n🔧 COMO USAR:\n1. Use para agrupar condições OR quando combinar com AND\n2. Abre antes do grupo de condições\n3. Sempre feche com )\n\n✏️ EXEMPLOS:\n• WHERE cargo = 'Dev' AND (cidade = 'SP' OR cidade = 'RJ')\n• WHERE id = 'X' AND (data LIKE '%21%' OR data LIKE '%22%')\n\n💡 DICA: Parênteses controlam a ordem de avaliação das condições",
	")": "📌 ) (parêntese fechado): Fecha o agrupamento de condições.\n\n🔧 COMO USAR:\n1. Fecha cada ( que você abriu\n2. Coloque após o último item do grupo\n3. Todo ( precisa de um )\n\n✏️ EXEMPLOS:\n• (condição1 OR condição2)\n• (data LIKE '%20%' OR data LIKE '%21%')\n\n💡 DICA: Conte os parênteses - sempre mesmo número de ( e )",
	"ORDER BY": "📌 ORDER BY: Ordena os resultados por uma ou mais colunas.\n\n🔧 COMO USAR:\n1. Coloque depois de WHERE (ou FROM se não tiver WHERE)\n2. Especifique a coluna para ordenar\n3. Use ASC (crescente) ou DESC (decrescente) - padrão é ASC\n\n✏️ EXEMPLOS:\n• ORDER BY nome\n• ORDER BY timestamp_login\n• ORDER BY idade DESC, nome ASC\n\n💡 DICA: Útil para criar timelines ou ver dados em ordem alfabética",
	"LIMIT": "📌 LIMIT: Limita o número de linhas retornadas no resultado.\n\n🔧 COMO USAR:\n1. Coloque no final da consulta\n2. Especifique quantas linhas quer ver\n3. Combine com ORDER BY para ver os 'top N'\n\n✏️ EXEMPLOS:\n• LIMIT 5 (mostra apenas 5 linhas)\n• LIMIT 10\n• ORDER BY salario DESC LIMIT 3 (top 3 salários)\n\n💡 DICA: Perfeito para ver apenas os primeiros resultados de uma lista grande",
	"ASC": "📌 ASC (Ascendente): Ordena do MENOR para o MAIOR (crescente).\n\n🔧 COMO USAR:\n1. Use após ORDER BY\n2. É o padrão (pode omitir)\n3. Ordem: A→Z, 0→9, mais antigo→mais recente\n\n✏️ EXEMPLOS:\n• ORDER BY nome ASC (A até Z)\n• ORDER BY idade ASC (mais jovem primeiro)\n• ORDER BY salario ASC (menor salário primeiro)\n• ORDER BY data ASC (mais antigo primeiro)\n\n💡 DICA: ASC é opcional - ORDER BY já ordena crescente por padrão",
	"DESC": "📌 DESC (Descendente): Ordena do MAIOR para o MENOR (decrescente).\n\n🔧 COMO USAR:\n1. Use após ORDER BY\n2. Inverte a ordem padrão\n3. Ordem: Z→A, 9→0, mais recente→mais antigo\n\n✏️ EXEMPLOS:\n• ORDER BY nome DESC (Z até A)\n• ORDER BY idade DESC (mais velho primeiro)\n• ORDER BY salario DESC (maior salário primeiro)\n• ORDER BY data DESC (mais recente primeiro)\n\n💡 DICA: DESC é útil para ver rankings (top 10, maiores valores, etc)",
	"Alias": "📌 Alias (f, a, t, l): Apelidos curtos para tabelas.\n\n🔧 COMO USAR:\n1. Escreva o alias após o nome da tabela\n2. Use o alias ao referenciar colunas\n3. Torna queries complexas mais legíveis\n\n✏️ EXEMPLOS:\n• FROM Funcionarios f (f é o alias)\n• FROM Arquivos_Servidor a\n• SELECT f.nome, a.arquivo FROM Funcionarios f JOIN Arquivos a\n\n💡 DICA: Use aliases curtos em JOINs para facilitar a escrita"
}

func mostrar_ajuda_sql():
	# Cria janela popup
	var popup = create_popup_ajuda_sql()
	add_child(popup)
	popup.popup_centered()

func create_popup_ajuda_sql() -> Window:
	var popup = Window.new()
	popup.title = "📚 Glossário de Comandos SQL"
	popup.size = Vector2i(1000, 700)  # Aumentado de 700x500 para 1000x700
	popup.wrap_controls = true
	popup.close_requested.connect(popup.queue_free)  # Faz o X funcionar

	# Container principal com scroll
	var scroll = ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	popup.add_child(scroll)

	# VBoxContainer para organizar os comandos
	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 15)  # Adiciona espaçamento de 15px entre itens
	scroll.add_child(vbox)

	# Título
	var titulo = Label.new()
	titulo.text = "📚 GLOSSÁRIO DE COMANDOS SQL\n"
	titulo.add_theme_font_size_override("font_size", 32)  # Aumentado de 24 para 32
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(titulo)

	# Adiciona cada comando do glossário
	var comandos_ordenados = ["SELECT", "FROM", "WHERE", "JOIN", "ON", "AND", "OR", "LIKE", "=", "!=", "DISTINCT", "ORDER BY", "ASC", "DESC", "LIMIT", "*", ",", "(", ")", "Alias"]

	for comando in comandos_ordenados:
		if glossario_sql.has(comando):
			var label = RichTextLabel.new()
			label.bbcode_enabled = true
			label.fit_content = true
			label.scroll_active = false
			label.custom_minimum_size = Vector2(920, 200)  # Aumentado para 200 para acomodar tutoriais
			label.text = glossario_sql[comando] + "\n"
			label.add_theme_font_size_override("normal_font_size", 18)  # Aumentado de 14 para 18
			vbox.add_child(label)

			# Separador
			var separador = HSeparator.new()
			vbox.add_child(separador)

	# Botão para fechar
	var botao_fechar = Button.new()
	botao_fechar.text = "✖ Fechar"
	botao_fechar.custom_minimum_size = Vector2(150, 50)  # Aumentado de 100x40 para 150x50
	botao_fechar.add_theme_font_size_override("font_size", 20)  # Adicionado tamanho de fonte maior
	botao_fechar.pressed.connect(popup.queue_free)

	# Adiciona som de hover
	botao_fechar.mouse_entered.connect(_on_botao_hover)

	vbox.add_child(botao_fechar)

	return popup

func avancar_para_caso(numero_caso: int):
	# Remove o botão de próximo caso (agora está no Painel_Console)
	var painel_console = $Painel_Console
	var botao_proximo = painel_console.get_node_or_null("BotaoProximoCaso")
	if botao_proximo:
		botao_proximo.queue_free()

	# Remove o botão de dica do caso anterior (está no Painel_Console)
	var botao_dica = painel_console.get_node_or_null("BotaoDica")
	if botao_dica:
		botao_dica.queue_free()

	# Remove o botão de Ajuda SQL (está no Painel_Console, será recriado no próximo caso)
	var botao_ajuda = painel_console.get_node_or_null("BotaoAjudaSQL")
	if botao_ajuda:
		botao_ajuda.queue_free()

	# Limpa resultados e feedback
	limpar_resultados()

	# Carrega o novo caso
	carregar_caso(numero_caso)

func exibir_mensagem_falha(argumento = null):
	# Incrementa contador de tentativas erradas
	tentativas_erradas += 1
	print("Tentativa errada #", tentativas_erradas)

	if feedback_label:
		var texto_erro = ""
		if argumento is Array:
			var sequencia_jogador = argumento
			var dica = ""

			# Verifica problemas comuns e fornece dicas específicas
			if sequencia_jogador.is_empty():
				dica = "A área de montagem está vazia! Para consultar o banco de dados, você precisa construir uma query SQL. Comece dando duplo clique ou arrastando o bloco 'SELECT'."

			elif not "SELECT" in sequencia_jogador:
				dica = "Toda consulta SQL precisa começar com SELECT! Este comando indica quais colunas você quer visualizar. Adicione o bloco 'SELECT' primeiro."

			elif sequencia_jogador[0] != "SELECT":
				dica = "A estrutura está quase correta, mas SELECT sempre deve ser o PRIMEIRO comando da consulta. Reorganize os blocos colocando SELECT no início."

			elif "SELECT" in sequencia_jogador and sequencia_jogador.size() < 2:
				dica = "SELECT está correto, mas SELECT o quê? Você precisa especificar quais colunas deseja ver (exemplo: nome_completo, cargo, etc.) ou usar * para todas."

			elif not "FROM" in sequencia_jogador:
				dica = "Você especificou as colunas com SELECT, mas falta indicar DE ONDE vêm esses dados. Adicione o comando 'FROM' seguido do nome da tabela."

			elif "FROM" in sequencia_jogador:
				var from_index = sequencia_jogador.find("FROM")
				if from_index >= sequencia_jogador.size() - 1:
					dica = "Você usou FROM, mas não especificou a tabela! Após FROM, indique qual tabela consultar (exemplo: Funcionarios, Arquivos_Servidor, etc.)."
				elif sequencia_jogador.has("WHERE"):
					var where_index = sequencia_jogador.find("WHERE")
					if where_index >= sequencia_jogador.size() - 1:
						dica = "WHERE está presente, mas falta a condição de filtro! Após WHERE, especifique a condição (exemplo: departamento = 'TI')."
					else:
						dica = "A query está quase completa, mas algo não está correto. Revise: a ordem dos blocos está certa? Todas as condições foram incluídas? Algum operador está faltando?"
				else:
					dica = "Verifique se a estrutura está completa. Confira: SELECT está primeiro? FROM está antes da tabela? Falta algum filtro WHERE? A ordem está correta?"

			else:
				dica = "A consulta não está correta. Dica: releia com atenção o que a missão está pedindo. Verifique se você está usando as colunas, tabelas e condições corretas. Clique nos blocos para removê-los e tente novamente."

			texto_erro = "Query Incorreta!\nDica: " + dica

		elif argumento is String:
			texto_erro = argumento

		else:
			texto_erro = "Query Incorreta!\nDica: Revise a ordem dos blocos e tente montar a consulta novamente."

		feedback_label.text = texto_erro
		feedback_label.add_theme_color_override("font_color", Color.ORANGE_RED)
		feedback_label.visible = true

		# Verifica se deve mostrar dica automática
		verificar_dica_automatica()
	else:
		printerr("ERRO: Referência 'feedback_label' é inválida ao tentar exibir falha!")

func verificar_dica_automatica():
	# Se dicas automáticas estiverem ativadas e atingiu o número de tentativas
	if Configuracoes.mostrar_dicas_automaticas:
		if tentativas_erradas >= Configuracoes.tentativas_para_dica_automatica:
			print("Mostrando dica automática após ", tentativas_erradas, " tentativas")
			mostrar_proxima_dica()
			tentativas_erradas = 0  # Reseta contador após mostrar dica

# --- FUNÇÃO PARA APLICAR TAMANHO DE FONTE ---
func aplicar_tamanho_fonte():
	var tamanho_base = 16  # Tamanho padrão

	match Configuracoes.tamanho_fonte:
		"pequeno":
			tamanho_base = 14
		"normal":
			tamanho_base = 16
		"grande":
			tamanho_base = 20

	# Aplica ao label da missão
	if missao_label:
		missao_label.add_theme_font_size_override("font_size", tamanho_base + 2)

	# Aplica ao feedback_label
	if feedback_label:
		feedback_label.add_theme_font_size_override("font_size", tamanho_base)

	print("Tamanho de fonte aplicado: ", Configuracoes.tamanho_fonte, " (", tamanho_base, "px)")

# --- FUNÇÕES DE CATEGORIA DE BLOCOS ---

# Função chamada quando um botão de categoria é clicado
func _on_categoria_selecionada(categoria: String):
	categoria_atual = categoria
	atualizar_visual_botoes_categoria()
	renderizar_blocos()

# Atualiza o visual dos botões de categoria para destacar o selecionado
func atualizar_visual_botoes_categoria():
	var botoes = [
		{"node": btn_todos, "categoria": "todos"},
		{"node": btn_comandos, "categoria": "comandos"},
		{"node": btn_operadores, "categoria": "operadores"},
		{"node": btn_dados, "categoria": "dados"}
	]

	for item in botoes:
		var botao = item["node"]
		var categoria = item["categoria"]

		if not botao:
			continue

		# Remove estilos anteriores
		botao.remove_theme_stylebox_override("normal")
		botao.remove_theme_stylebox_override("hover")
		botao.remove_theme_stylebox_override("pressed")
		botao.remove_theme_color_override("font_color")

		# Cria estilo para o botão
		var style = StyleBoxFlat.new()
		style.corner_radius_top_left = 5
		style.corner_radius_top_right = 5
		style.corner_radius_bottom_left = 5
		style.corner_radius_bottom_right = 5
		# Adiciona padding interno para dar mais espaço
		style.content_margin_left = 10
		style.content_margin_right = 10
		style.content_margin_top = 5
		style.content_margin_bottom = 5

		if categoria == categoria_atual:
			# Botão selecionado - destaca com cor mais escura
			if categoria == "comandos":
				style.bg_color = Color(0.2, 0.4, 0.8, 1.0)  # Azul
			elif categoria == "operadores":
				style.bg_color = Color(0.6, 0.3, 0.8, 1.0)  # Roxo
			elif categoria == "dados":
				style.bg_color = Color(0.2, 0.7, 0.3, 1.0)  # Verde
			else:  # "todos"
				style.bg_color = Color(0.4, 0.4, 0.4, 1.0)  # Cinza escuro
			botao.add_theme_color_override("font_color", Color.WHITE)
		else:
			# Botão não selecionado - cor mais clara
			style.bg_color = Color(0.25, 0.25, 0.25, 1.0)  # Cinza bem escuro
			botao.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 1.0))  # Cinza claro

		botao.add_theme_stylebox_override("normal", style)

		# Estilo hover
		var style_hover = style.duplicate()
		style_hover.bg_color = style_hover.bg_color.lightened(0.2)
		botao.add_theme_stylebox_override("hover", style_hover)

		# Estilo pressed (mesmo que normal para evitar movimento)
		var style_pressed = style.duplicate()
		botao.add_theme_stylebox_override("pressed", style_pressed)
