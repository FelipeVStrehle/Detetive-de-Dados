extends Control

@onready var btn_voltar = $BtnVoltar

func _ready():
	# Adiciona som de hover ao botão
	if btn_voltar:
		btn_voltar.mouse_entered.connect(_on_botao_hover)
		btn_voltar.grab_focus()

func _on_botao_hover():
	Configuracoes.tocar_som_hover()

func _on_btn_voltar_pressed():
	# Música continua tocando ao voltar
	# Retorna ao menu principal
	GerenciadorCenas.trocar_cena("res://menu_principal.tscn")
