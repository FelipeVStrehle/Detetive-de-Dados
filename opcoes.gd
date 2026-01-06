extends Control

# Referências aos controles de áudio
@onready var slider_musica = $PainelPrincipal/MarginContainer/VBox/ScrollContainer/OpcoesContainer/VolumeMusica/Slider
@onready var label_musica = $PainelPrincipal/MarginContainer/VBox/ScrollContainer/OpcoesContainer/VolumeMusica/Valor
@onready var slider_efeitos = $PainelPrincipal/MarginContainer/VBox/ScrollContainer/OpcoesContainer/VolumeEfeitos/Slider
@onready var label_efeitos = $PainelPrincipal/MarginContainer/VBox/ScrollContainer/OpcoesContainer/VolumeEfeitos/Valor
@onready var check_mutar = $PainelPrincipal/MarginContainer/VBox/ScrollContainer/OpcoesContainer/MutarAudio/CheckBox

# Referências aos controles de interface
@onready var option_velocidade = $PainelPrincipal/MarginContainer/VBox/ScrollContainer/OpcoesContainer/VelocidadeTexto/OptionButton
@onready var check_dicas_auto = $PainelPrincipal/MarginContainer/VBox/ScrollContainer/OpcoesContainer/DicasAutomaticas/CheckBox

# Referências aos controles de acessibilidade
@onready var option_fonte = $PainelPrincipal/MarginContainer/VBox/ScrollContainer/OpcoesContainer/TamanhoFonte/OptionButton

# Referências aos controles de jogo
@onready var check_resultados = $PainelPrincipal/MarginContainer/VBox/ScrollContainer/OpcoesContainer/MostrarResultados/CheckBox
@onready var check_aprendizado = $PainelPrincipal/MarginContainer/VBox/ScrollContainer/OpcoesContainer/ModoAprendizado/CheckBox

# Variável para saber de onde veio (menu principal ou pausa)
var veio_do_menu_pausa = false
var menu_pausa_referencia = null  # Referência ao menu de pausa

func _ready():
	# Permite que o menu de opções funcione mesmo quando o jogo está pausado
	configurar_process_mode_recursivo(self)

	# Adiciona som de hover aos botões
	adicionar_som_hover_botoes()

	carregar_valores_atuais()

func adicionar_som_hover_botoes():
	# Encontra todos os botões da tela
	var botoes_container = $PainelPrincipal/MarginContainer/VBox
	if botoes_container:
		for child in botoes_container.get_children():
			if child is Button:
				child.mouse_entered.connect(_on_botao_hover)

func _on_botao_hover():
	Configuracoes.tocar_som_hover()

# Configura todos os nós para funcionar durante a pausa
func configurar_process_mode_recursivo(node: Node):
	node.process_mode = Node.PROCESS_MODE_ALWAYS
	for child in node.get_children():
		configurar_process_mode_recursivo(child)

# Atualiza a interface do jogo com as novas configurações
func atualizar_interface_jogo():
	# Procura pela cena UI_Principal no jogo
	var ui_principal = get_tree().root.get_node_or_null("UI_Principal")
	if ui_principal and ui_principal.has_method("aplicar_tamanho_fonte"):
		ui_principal.aplicar_tamanho_fonte()
		print("Interface do jogo atualizada com novo tamanho de fonte!")

# Atualiza os botões de ajuda no jogo (mostra/esconde baseado no modo aprendizado)
func atualizar_botoes_ajuda_jogo():
	var ui_principal = get_tree().root.get_node_or_null("UI_Principal")
	if not ui_principal:
		return

	var painel_console = ui_principal.get_node_or_null("Painel_Console")
	if not painel_console:
		return

	# Remove botões existentes
	var botao_dica = painel_console.get_node_or_null("BotaoDica")
	var botao_ajuda = painel_console.get_node_or_null("BotaoAjudaSQL")

	if botao_dica:
		botao_dica.queue_free()
	if botao_ajuda:
		botao_ajuda.queue_free()

	# Se modo aprendizado está ativo, recria os botões
	if Configuracoes.modo_aprendizado:
		# Chama as funções de criação dos botões do ui_principal
		if ui_principal.has_method("criar_botao_dica"):
			ui_principal.criar_botao_dica()
		if ui_principal.has_method("criar_botao_ajuda_sql"):
			ui_principal.criar_botao_ajuda_sql()
		print("Botões de ajuda reativados!")
	else:
		print("Botões de ajuda removidos (modo aprendizado desativado)")

# --- CARREGAR VALORES DAS CONFIGURAÇÕES ---
func carregar_valores_atuais():
	# Áudio
	slider_musica.value = Configuracoes.volume_musica
	label_musica.text = str(int(Configuracoes.volume_musica * 100)) + "%"

	slider_efeitos.value = Configuracoes.volume_efeitos
	label_efeitos.text = str(int(Configuracoes.volume_efeitos * 100)) + "%"

	check_mutar.button_pressed = Configuracoes.audio_mutado

	# Interface
	match Configuracoes.velocidade_texto:
		0.03: option_velocidade.selected = 0  # Lenta
		0.02: option_velocidade.selected = 1  # Normal
		0.01: option_velocidade.selected = 2  # Rápida
		_: option_velocidade.selected = 1

	check_dicas_auto.button_pressed = Configuracoes.mostrar_dicas_automaticas

	# Acessibilidade
	match Configuracoes.tamanho_fonte:
		"pequeno": option_fonte.selected = 0
		"normal": option_fonte.selected = 1
		"grande": option_fonte.selected = 2
		_: option_fonte.selected = 1

	# Jogo
	check_resultados.button_pressed = Configuracoes.mostrar_resultados_sql
	check_aprendizado.button_pressed = Configuracoes.modo_aprendizado

# --- CALLBACKS DE MUDANÇA DE VALORES ---

func _on_volume_musica_changed(value: float):
	Configuracoes.volume_musica = value
	label_musica.text = str(int(value * 100)) + "%"

func _on_volume_efeitos_changed(value: float):
	Configuracoes.volume_efeitos = value
	label_efeitos.text = str(int(value * 100)) + "%"

func _on_mutar_audio_toggled(toggled_on: bool):
	Configuracoes.audio_mutado = toggled_on
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)

func _on_velocidade_texto_selected(index: int):
	match index:
		0: Configuracoes.velocidade_texto = 0.03  # Lenta
		1: Configuracoes.velocidade_texto = 0.02  # Normal
		2: Configuracoes.velocidade_texto = 0.01  # Rápida

	# A velocidade do texto será aplicada automaticamente no próximo caso

func _on_dicas_automaticas_toggled(toggled_on: bool):
	Configuracoes.mostrar_dicas_automaticas = toggled_on

func _on_tamanho_fonte_selected(index: int):
	match index:
		0: Configuracoes.tamanho_fonte = "pequeno"
		1: Configuracoes.tamanho_fonte = "normal"
		2: Configuracoes.tamanho_fonte = "grande"

	# Se estiver no jogo (veio do menu de pausa), atualiza a interface imediatamente
	if veio_do_menu_pausa:
		atualizar_interface_jogo()

func _on_mostrar_resultados_toggled(toggled_on: bool):
	Configuracoes.mostrar_resultados_sql = toggled_on
	# Resultados serão aplicados na próxima execução de query

func _on_modo_aprendizado_toggled(toggled_on: bool):
	Configuracoes.modo_aprendizado = toggled_on

	# Se estiver no jogo, atualiza os botões de ajuda imediatamente
	if veio_do_menu_pausa:
		atualizar_botoes_ajuda_jogo()

# --- BOTÕES ---

func _on_btn_resetar_pressed():
	Configuracoes.resetar_para_padrao()
	carregar_valores_atuais()
	print("Configurações resetadas para o padrão!")

func _on_btn_salvar_pressed():
	Configuracoes.salvar_configuracoes()
	print("Configurações salvas!")

	# Se veio do menu de pausa, volta para o menu de pausa
	if veio_do_menu_pausa:
		# Re-mostra o menu de pausa
		if menu_pausa_referencia and is_instance_valid(menu_pausa_referencia):
			menu_pausa_referencia.visible = true
		queue_free()  # Remove a tela de opções
	else:
		# Se veio do menu principal, volta para lá (música continua tocando)
		GerenciadorCenas.trocar_cena("res://menu_principal.tscn")

func _on_btn_cancelar_pressed():
	# Recarrega as configurações originais (descarta mudanças)
	Configuracoes.carregar_configuracoes()
	print("Mudanças descartadas!")

	# Se veio do menu de pausa, volta para o menu de pausa
	if veio_do_menu_pausa:
		# Re-mostra o menu de pausa
		if menu_pausa_referencia and is_instance_valid(menu_pausa_referencia):
			menu_pausa_referencia.visible = true
		queue_free()  # Remove a tela de opções
	else:
		# Se veio do menu principal, volta para lá (música continua tocando)
		GerenciadorCenas.trocar_cena("res://menu_principal.tscn")
