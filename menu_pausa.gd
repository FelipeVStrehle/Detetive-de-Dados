extends CanvasLayer

# Referências aos botões
@onready var btn_continuar = $PainelCentral/VBoxContainer/BtnContinuar
@onready var btn_opcoes = $PainelCentral/VBoxContainer/BtnOpcoes
@onready var btn_menu_principal = $PainelCentral/VBoxContainer/BtnMenuPrincipal

func _ready():
	# Esconde o menu ao iniciar
	visible = false

	# Adiciona som de hover aos botões
	adicionar_som_hover_botoes()

func adicionar_som_hover_botoes():
	# Conecta som de hover aos botões
	if btn_continuar:
		btn_continuar.mouse_entered.connect(_on_botao_hover)
	if btn_opcoes:
		btn_opcoes.mouse_entered.connect(_on_botao_hover)
	if btn_menu_principal:
		btn_menu_principal.mouse_entered.connect(_on_botao_hover)

func _on_botao_hover():
	Configuracoes.tocar_som_hover()

func _input(event):
	# Detecta a tecla ESC
	if event.is_action_pressed("ui_cancel"):  # ui_cancel é ESC por padrão
		alternar_pausa()

func alternar_pausa():
	visible = !visible
	get_tree().paused = visible

	# Se ficou visível, foca no botão Continuar
	if visible and btn_continuar:
		btn_continuar.grab_focus()

func _on_btn_continuar_pressed():
	alternar_pausa()

func _on_btn_opcoes_pressed():
	# Carrega a cena de opções como overlay
	var opcoes_scene = load("res://opcoes.tscn")
	var opcoes_instance = opcoes_scene.instantiate()
	opcoes_instance.veio_do_menu_pausa = true
	opcoes_instance.menu_pausa_referencia = self  # Passa referência do menu de pausa
	get_tree().root.add_child(opcoes_instance)

	# Esconde o menu de pausa temporariamente
	visible = false

func _on_btn_menu_principal_pressed():
	# Despausa o jogo antes de trocar de cena
	get_tree().paused = false
	# Retorna ao menu principal com efeito de fade
	GerenciadorCenas.trocar_cena("res://menu_principal.tscn")
