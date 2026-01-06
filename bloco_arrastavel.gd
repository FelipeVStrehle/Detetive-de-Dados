extends Button

# Variável para guardar o texto do bloco (ex: "SELECT", "nome_completo")
var bloco_texto : String = ""

# Variáveis para controle de duplo clique
var ultimo_clique_tempo : float = 0.0
var tempo_duplo_clique : float = 0.4  # 400ms para duplo clique

func _ready():
	# Pega o texto do próprio botão e guarda na variável
	bloco_texto = self.text

	# Conecta o sinal de pressed para detectar cliques
	self.pressed.connect(_on_bloco_pressed)

# Função chamada quando o bloco é clicado
func _on_bloco_pressed():
	var tempo_atual = Time.get_ticks_msec() / 1000.0
	var tempo_desde_ultimo_clique = tempo_atual - ultimo_clique_tempo

	# Verifica se foi duplo clique
	if tempo_desde_ultimo_clique < tempo_duplo_clique:
		# DUPLO CLIQUE DETECTADO!
		adicionar_bloco_na_area_montagem()
		ultimo_clique_tempo = 0.0  # Reseta o timer
	else:
		# Primeiro clique
		ultimo_clique_tempo = tempo_atual

# Função para adicionar bloco na área de montagem (sem arrastar)
func adicionar_bloco_na_area_montagem():
	print("Duplo clique detectado! Adicionando bloco: ", bloco_texto)

	# Encontra a área de montagem na cena principal
	var ui_principal = get_tree().root.get_node_or_null("UI_Principal")
	if not ui_principal:
		printerr("ERRO: UI_Principal não encontrado!")
		return

	var area_montagem = ui_principal.get_node_or_null("Painel_Console/Panel/ScrollContainer_Montagem/Area_Montagem")
	if not area_montagem:
		printerr("ERRO: Area_Montagem não encontrado!")
		return

	# Cria uma cópia do bloco para adicionar na área de montagem
	# Usa a MESMA lógica do area_montagem.gd para manter consistência visual
	var novo_bloco = Label.new()
	novo_bloco.text = bloco_texto

	# Configuração de mouse (permite clique para remover)
	novo_bloco.mouse_filter = Control.MOUSE_FILTER_STOP

	# Cria estilo igual ao usado quando arrasta
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.3, 0.3, 0.3, 0.9)  # Cor de fundo padrão (cinza)
	style_box.border_width_left = 1
	style_box.border_width_top = 1
	style_box.border_width_right = 1
	style_box.border_width_bottom = 1
	style_box.border_color = Color(0.6, 0.6, 0.6)
	style_box.corner_radius_top_left = 3
	style_box.corner_radius_top_right = 3
	style_box.corner_radius_bottom_left = 3
	style_box.corner_radius_bottom_right = 3
	style_box.content_margin_left = 8      # Padding horizontal
	style_box.content_margin_right = 8
	style_box.content_margin_top = 4       # Padding vertical
	style_box.content_margin_bottom = 4

	novo_bloco.add_theme_stylebox_override("normal", style_box)

	# Tamanho mínimo: largura automática (0), altura 35px
	novo_bloco.custom_minimum_size = Vector2(0, 35)

	# Centraliza o texto
	novo_bloco.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	novo_bloco.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# Conecta sinal para remover bloco ao clicar (mesma funcionalidade do arrastar)
	novo_bloco.connect("gui_input", Callable(area_montagem, "_on_bloco_solto_gui_input").bind(novo_bloco))

	# Adiciona na área de montagem
	area_montagem.add_child(novo_bloco)
	print("Bloco '", bloco_texto, "' adicionado na área de montagem via duplo clique!")

# Função chamada pelo Godot quando um arrastar começa neste nó
func _get_drag_data(_at_position):
	print("Iniciando arrastar do bloco: ", bloco_texto)

	# 1. O que vamos "carregar" durante o arrastar: nosso próprio texto
	var data_to_drag = bloco_texto

	# 2. Criar uma pré-visualização (o que o mouse vai mostrar enquanto arrasta)
	var preview = Label.new()
	preview.text = bloco_texto
	# Opcional: Estilizar a pré-visualização
	preview.modulate = Color(1, 1, 1, 0.7) # Deixa um pouco transparente
	preview.size = self.size # Mesmo tamanho do botão

	# 3. Define a pré-visualização e os dados
	set_drag_preview(preview)
	return data_to_drag
