extends Control

func _ready():
	# Adiciona som de hover a todos os botões do menu
	adicionar_som_hover_botoes()

	# Toca a música do menu
	Configuracoes.tocar_musica_menu()

func adicionar_som_hover_botoes():
	# Encontra todos os botões filhos do VBoxContainer
	var vbox = $VBoxContainer
	if vbox:
		for child in vbox.get_children():
			if child is Button:
				# Conecta o sinal mouse_entered ao som
				child.mouse_entered.connect(_on_botao_hover)

func _on_botao_hover():
	# Toca o som de hover
	Configuracoes.tocar_som_hover()

# Chamado quando o botão Iniciar Jogo é pressionado
func _on_botao_iniciar_pressed():
	# Para a música do menu antes de iniciar o jogo
	Configuracoes.parar_musica()
	# Usa nosso Gerenciador de Cenas global para ir para a cena de INTRODUÇÃO
	GerenciadorCenas.trocar_cena("res://intro_terminal.tscn") # <-- Caminho atualizado

# Chamado quando o botão História do SQL é pressionado
func _on_botao_historia_sql_pressed():
	# Para a música do menu
	Configuracoes.parar_musica()
	# Vai para a cena de História do SQL
	GerenciadorCenas.trocar_cena("res://historia_sql.tscn")

# Chamado quando o botão Opções é pressionado
func _on_botao_opcoes_pressed():
	# Música continua tocando nas opções
	GerenciadorCenas.trocar_cena("res://opcoes.tscn")

# Chamado quando o botão Créditos é pressionado
func _on_botao_creditos_pressed():
	# Música continua tocando nos créditos
	GerenciadorCenas.trocar_cena("res://creditos.tscn")

# Chamado quando o botão Sair é pressionado
func _on_botao_sair_pressed():
	# Comando padrão da Godot para fechar o jogo
	get_tree().quit()
