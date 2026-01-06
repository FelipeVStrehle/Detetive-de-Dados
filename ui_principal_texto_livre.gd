extends Control

# Nossas referências para os nós da interface
@onready var input_sql = $Painel_Console/Input_SQL
@onready var grid_resultados = $Painel_Resultados/GridResultados

# DB instanciado de forma lazy para evitar crash no editor
var db = null
var db_aberto = false

func _ready():
	# PROTEÇÃO: NÃO executa código de banco de dados no editor
	if Engine.is_editor_hint():
		print("Modo Editor detectado - inicialização de DB ignorada.")
		return

	print("Interface de texto livre pronta.")


# --- NOVAS FUNÇÕES AJUDANTES ---

# Função para limpar qualquer resultado anterior da grade
func limpar_resultados():
	for n in grid_resultados.get_children():
		n.queue_free() # 'queue_free' destrói o nó de forma segura

# Função para pegar os dados e criar os Labels na grade
func exibir_resultados(dados):
	# Se não houver dados, exibe uma mensagem
	if dados.size() == 0:
		var celula_vazia = Label.new()
		celula_vazia.text = "Nenhum resultado encontrado."
		grid_resultados.add_child(celula_vazia)
		return

	# Pega os nomes das colunas do primeiro resultado para criar o cabeçalho
	var colunas = dados[0].keys()
	for nome_coluna in colunas:
		var cabecalho = Label.new()
		cabecalho.text = nome_coluna.capitalize() # Deixa a primeira letra maiúscula
		# Opcional: Adiciona um estilo para o cabeçalho se destacar
		cabecalho.add_theme_font_size_override("font_size", 20)
		cabecalho.add_theme_color_override("font_color", Color.YELLOW)
		grid_resultados.add_child(cabecalho)
		
	# Agora, percorre cada linha dos dados
	for linha in dados:
		# E para cada coluna na linha, cria uma célula de texto
		for nome_coluna in colunas:
			var celula = Label.new()
			celula.text = str(linha[nome_coluna]) # Converte o valor para texto
			grid_resultados.add_child(celula)


# --- FUNÇÃO PRINCIPAL DO BOTÃO (ATUALIZADA) ---

func _on_button_pressed():
	# LAZY LOADING: Instancia e abre o DB apenas na primeira execução
	if not db_aberto:
		# Instancia SQLite APENAS quando necessário (evita crash no editor)
		db = SQLite.new()
		var db_path = "res://casos.db"
		db.path = db_path
		if db.open_db():
			print("Banco de dados 'casos.db' aberto com sucesso.")
			db_aberto = true
		else:
			printerr("ERRO CRÍTICO: Não foi possível abrir o banco de dados!")
			var erro_label = Label.new()
			erro_label.text = "Erro ao conectar ao banco de dados. Verifique o arquivo 'casos.db'."
			erro_label.add_theme_color_override("font_color", Color.RED)
			grid_resultados.add_child(erro_label)
			return

	# 1. Sempre limpa os resultados antigos primeiro
	limpar_resultados()

	var query_texto = input_sql.text

	# Garante que o jogador digitou algo
	if query_texto.is_empty():
		return

	print("Executando a query: ", query_texto)
	var sucesso = db.query(query_texto)

	if sucesso:
		var resultado = db.query_result
		print("Query retornou %s resultados." % resultado.size())
		# 2. Manda os novos resultados para serem exibidos na tela
		exibir_resultados(resultado)
	else:
		# Exibe a mensagem de erro na tela para o jogador
		var erro_label = Label.new()
		erro_label.text = "Erro ao executar a query. Verifique a sintaxe."
		erro_label.add_theme_color_override("font_color", Color.RED)
		grid_resultados.add_child(erro_label)
