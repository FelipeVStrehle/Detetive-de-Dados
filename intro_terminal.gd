extends Control

# Referências aos nós da interface
@onready var texto_briefing = $MarginContainer/RichTextLabel # Ajuste se necessário
@onready var prompt_continuar = $Label # Ajuste se necessário

# Texto completo do briefing
var texto_completo = """
[b]ASSUNTO:[/b] URGENTE - Violação de Dados [Nível 5]
[b]CLIENTE:[/b] Delegacia de Crimes Cibernéticos de Alta Tecnologia
[b]AGÊNCIA:[/b] Dados & Decisões
[b]DESIGNADO PARA:[/b] Detetive de Dados (Você)

[ [b]INÍCIO DO BRIEFING[/b] ]

Você foi convocado para uma reunião de emergência na sala principal da agência. Sua chefe, Ada, apresenta o cliente: Delegado Turing, da divisão de Crimes Cibernéticos.

O Delegado explica a situação com urgência:
"Esta noite, a DataCorp sofreu uma violação de segurança catastrófica. O alvo foi o projeto mais secreto deles, conhecido apenas como 'Projeto Nexus' — um ativo avaliado em bilhões.
O invasor foi um profissional. Ele entrou no núcleo do servidor às 02:17 da manhã, sem disparar um único alarme.
Ele não destruiu nada. Ele não pediu resgate. Ele fez algo pior: copiou 10 Gigabytes de dados proprietários e desapareceu.
Para cobrir os rastros, o ataque foi disfarçado como uma 'corrupção de dados' acidental. A TI local só percebeu o roubo horas depois.
Temos um trabalho interno nas mãos. Não há impressões digitais, não há câmeras. A única coisa que temos é o acesso ao log do banco de dados deles. Meus peritos são bons com arrombamentos, não com queries de SQL.
A DataCorp quer sigilo absoluto e respostas rápidas. Ada me disse que vocês são os melhores."

[ [b]FIM DO BRIEFING DO DELEGADO[/b] ]

Ada assume a palavra e direciona a missão a você:
"Muito bem, detetive. Você ouviu o homem. O caso está aberto. O Delegado Turing precisa de um ponto de partida.
Vamos começar pelo óbvio: quem diabos tinha acesso oficial ao 'Projeto Nexus'?
Abra seu terminal. Este é o seu caso agora."
"""

# Variáveis para o efeito máquina de escrever
var caractere_atual = 0
var velocidade_texto = 0.03
var timer = 0.0
var texto_terminou = false # Nova flag para controlar o estado

func _ready():
	# Inicia a música do jogo
	Configuracoes.tocar_musica_jogo()

	texto_briefing.text = texto_completo
	texto_briefing.visible_characters = 0
	texto_terminou = false

	if prompt_continuar:
		print("Nó 'prompt_continuar' encontrado com sucesso.")
		prompt_continuar.text = "[ Pressione Enter para Iniciar Investigação ]" # Define o texto via script
		prompt_continuar.visible = false # Garante que comece invisível
		prompt_continuar.add_theme_color_override("font_color", Color("00FF00"))
		prompt_continuar.add_theme_font_size_override("font_size", 24)
	else:
		print("ERRO CRÍTICO: Nó 'prompt_continuar' NÃO encontrado!")

	texto_briefing.add_theme_color_override("default_color", Color("00FF00"))
	texto_briefing.add_theme_font_size_override("normal_font_size", 24)

	set_process(true)

func _process(delta):
	# Se o texto já terminou, não faz mais nada aqui
	if texto_terminou:
		set_process(false) # Desabilita _process definitivamente
		return

	timer += delta
	var total_caracteres = texto_briefing.get_total_character_count()

	if timer >= velocidade_texto and caractere_atual < total_caracteres:
		timer = 0
		caractere_atual += 1
		texto_briefing.visible_characters = caractere_atual

	# Verifica se terminou AGORA
	if caractere_atual >= total_caracteres:
		texto_terminou = true # Marca que terminou
		if prompt_continuar:
			if not prompt_continuar.visible: # Só executa o debug e torna visível uma vez
				print("--- INSPECIONANDO prompt_continuar ANTES de torná-lo visível ---") # DEBUG
				print("Texto: '", prompt_continuar.text, "'")                            # DEBUG
				print("Visível (antes): ", prompt_continuar.visible)                    # DEBUG
				print("Posição Global: ", prompt_continuar.global_position)             # DEBUG
				print("Tamanho: ", prompt_continuar.size)                               # DEBUG
				print("Z Index: ", prompt_continuar.z_index)                           # DEBUG
				print("Modulate Alpha: ", prompt_continuar.modulate.a)                 # DEBUG
				print("Self Modulate Alpha: ", prompt_continuar.self_modulate.a)        # DEBUG
				print("----------------------------------------------------------------") # DEBUG

				prompt_continuar.visible = true # Mostra o prompt
				print("Definindo prompt como visível (depois): ", prompt_continuar.visible) # Confirmação # DEBUG
				print("Texto concluído. Prompt visível.")
		# else: # Desnecessário verificar 'else' aqui, já verificado no _ready

		set_process(false) # Desabilita _process APÓS garantir que o prompt está visível (se existir)

# --- FUNÇÃO _input ---
func _input(event):
	# Verifica se foi pressionada a tecla Enter OU qualquer botão do mouse
	var input_pressionado = event.is_action_pressed("ui_accept") or \
						   (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed)

	if input_pressionado:
		if not texto_terminou:
			# Se o texto AINDA NÃO terminou, acelera!
			print("Acelerando texto...")
			caractere_atual = texto_briefing.get_total_character_count() # Vai para o fim
			texto_briefing.visible_characters = -1 # Revela tudo (-1 mostra todos)
			texto_terminou = true # Marca que terminou
			if prompt_continuar:
				if not prompt_continuar.visible: # Só executa o debug e torna visível uma vez
					print("--- INSPECIONANDO prompt_continuar (Aceleração) ---") # DEBUG
					print("Texto: '", prompt_continuar.text, "'")                 # DEBUG
					print("Visível (antes): ", prompt_continuar.visible)         # DEBUG
					print("Posição Global: ", prompt_continuar.global_position)  # DEBUG
					print("Tamanho: ", prompt_continuar.size)                    # DEBUG
					print("Z Index: ", prompt_continuar.z_index)                # DEBUG
					print("Modulate Alpha: ", prompt_continuar.modulate.a)      # DEBUG
					print("Self Modulate Alpha: ", prompt_continuar.self_modulate.a) # DEBUG
					print("-----------------------------------------------------") # DEBUG

					prompt_continuar.visible = true # Mostra o prompt imediatamente
					print("Definindo prompt como visível (depois - Aceleração): ", prompt_continuar.visible) # Confirmação # DEBUG
				print("Texto acelerado. Prompt visível.")
			set_process(false) # Para o _process
		else:
			# Se o texto JÁ terminou (e o prompt está visível), avança a cena
			if prompt_continuar and prompt_continuar.visible:
				print("Avançando para o Caso 1...")
				GerenciadorCenas.trocar_cena("res://ui_principal.tscn")
# --- FIM DA FUNÇÃO _input ---
