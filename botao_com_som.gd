extends Button

func _ready():
	# Conecta o sinal de mouse_entered ao som de hover
	self.mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered():
	# Toca o som de hover através do sistema global
	Configuracoes.tocar_som_hover()
