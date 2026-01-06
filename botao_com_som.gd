extends Button

# Script para adicionar som de hover em botões
# Basta anexar este script a qualquer botão para ele tocar som ao passar o mouse

func _ready():
	# Conecta o sinal de mouse_entered ao som de hover
	self.mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered():
	# Toca o som de hover através do sistema global
	Configuracoes.tocar_som_hover()
