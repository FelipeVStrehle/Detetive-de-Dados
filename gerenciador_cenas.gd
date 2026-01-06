# No GerenciadorCenas.gd

extends Node # Ou CanvasLayer, dependendo do nó raiz que você escolheu

# Referências aos nós dentro desta cena (ajuste os caminhos se necessário)
@onready var fade_animator = $CanvasLayer/AnimationPlayer
@onready var fade_rect = $CanvasLayer/ColorRect # Precisamos para garantir o estado inicial

# Garante que comece transparente
func _ready():
	if fade_rect:
		fade_rect.modulate.a = 0.0 # Começa transparente

# Função ATUALIZADA para trocar de cena com fade
func trocar_cena(caminho_da_cena):
	print("Iniciando transição para: ", caminho_da_cena)

	# 1. Toca a animação de fade out
	if fade_animator:
		fade_animator.play("fade_out")
		# 2. ESPERA a animação terminar (IMPORTANTE!)
		# 'await' pausa a execução desta função até o sinal ser emitido
		await fade_animator.animation_finished
		print("Fade out concluído.")
	else:
		print("Alerta: FadeAnimator não encontrado!")
		# Se não houver animador, troca direto (comportamento antigo)
		get_tree().change_scene_to_file(caminho_da_cena)
		return # Sai da função aqui

	# 3. Troca a cena DEPOIS do fade out
	var erro = get_tree().change_scene_to_file(caminho_da_cena)
	if erro != OK:
		printerr("Erro ao carregar a cena: ", caminho_da_cena)
		# Mesmo com erro, tenta fazer o fade in para não travar na tela preta
		if fade_animator:
			fade_animator.play("fade_in")
		return

	# 4. Toca a animação de fade in APÓS a nova cena carregar
	# Adiciona uma pequena espera para garantir que a nova cena renderize o primeiro frame
	await get_tree().create_timer(0.1).timeout
	if fade_animator:
		print("Iniciando fade in...")
		fade_animator.play("fade_in")
		# Não precisamos esperar o fade in terminar aqui
