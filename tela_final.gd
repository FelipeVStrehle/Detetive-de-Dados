extends Control

# Referência ao botão
@onready var btn_menu_principal = $HSplitContainer/RightPanel/BtnMenuPrincipal

func _ready():
	# Inicia a música da tela final
	Configuracoes.tocar_musica_final()

	# Foca no botão ao iniciar
	if btn_menu_principal:
		btn_menu_principal.grab_focus()
		# Adiciona som de hover
		btn_menu_principal.mouse_entered.connect(_on_botao_hover)

func _on_botao_hover():
	Configuracoes.tocar_som_hover()

func _on_btn_menu_principal_pressed():
	# Inicia a música do menu ao retornar
	Configuracoes.tocar_musica_menu()
	# Retorna ao menu principal com efeito de fade
	GerenciadorCenas.trocar_cena("res://menu_principal.tscn")
