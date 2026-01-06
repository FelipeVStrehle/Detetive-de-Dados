extends Node

# ===================================
# AUTOLOAD DE CONFIGURAÇÕES GLOBAIS
# ===================================
# Este script gerencia todas as configurações do jogo
# e persiste as preferências do usuário

# --- CONFIGURAÇÕES DE ÁUDIO ---
var volume_musica: float = 0.8  # 0.0 a 1.0
var volume_efeitos: float = 0.8  # 0.0 a 1.0
var audio_mutado: bool = false

# --- PLAYER DE ÁUDIO PARA EFEITOS SONOROS ---
var audio_player_hover: AudioStreamPlayer = null
var som_hover: AudioStream = null

# --- PLAYER DE MÚSICA DE FUNDO ---
var audio_player_musica: AudioStreamPlayer = null
var musica_menu: AudioStream = null
var musica_jogo: AudioStream = null
var musica_final: AudioStream = null

# --- CONFIGURAÇÕES DE INTERFACE ---
var velocidade_texto: float = 0.02  # Velocidade do efeito typewriter (segundos por caractere)
var mostrar_dicas_automaticas: bool = false  # Mostrar dica após X tentativas erradas
var tentativas_para_dica_automatica: int = 3  # Quantas tentativas erradas antes da dica automática

# --- CONFIGURAÇÕES DE ACESSIBILIDADE ---
var tamanho_fonte: String = "normal"  # "pequeno", "normal", "grande"

# --- CONFIGURAÇÕES DE JOGO ---
var mostrar_resultados_sql: bool = true  # Mostrar tabela de resultados da query
var modo_aprendizado: bool = true  # Dicas e explicações extras

# --- CAMINHO DO ARQUIVO DE CONFIGURAÇÃO ---
const CONFIG_PATH = "user://configuracoes.cfg"

func _ready():
	# Configura o player de áudio para hover
	configurar_audio_hover()

	# Configura o player de música
	configurar_audio_musica()

	carregar_configuracoes()

# --- CONFIGURAR ÁUDIO DE HOVER ---
func configurar_audio_hover():
	# Carrega o som de hover
	som_hover = load("res://assets/Musicas/Menu Selection Click.wav")

	# Cria o AudioStreamPlayer
	audio_player_hover = AudioStreamPlayer.new()
	audio_player_hover.stream = som_hover
	audio_player_hover.volume_db = -5  # Volume um pouco reduzido
	audio_player_hover.bus = "Master"
	add_child(audio_player_hover)

	print("Sistema de áudio de hover configurado!")

# --- TOCAR SOM DE HOVER ---
func tocar_som_hover():
	if audio_player_hover and som_hover and not audio_mutado:
		# Ajusta volume baseado na configuração
		var volume_final = linear_to_db(volume_efeitos)
		audio_player_hover.volume_db = volume_final - 5  # -5 para não ficar muito alto
		audio_player_hover.play()
		#print("Som de hover tocado!")

# --- CONFIGURAR ÁUDIO DE MÚSICA ---
func configurar_audio_musica():
	# Carrega as músicas
	musica_menu = load("res://assets/Musicas/MusicaMenu.mp3")
	musica_jogo = load("res://assets/Musicas/MusicaJogo.wav")
	musica_final = load("res://assets/Musicas/MusicaFinal.wav")

	# Cria o AudioStreamPlayer para música
	audio_player_musica = AudioStreamPlayer.new()
	audio_player_musica.stream = musica_menu
	audio_player_musica.volume_db = -10  # Volume mais baixo que efeitos
	audio_player_musica.bus = "Master"
	add_child(audio_player_musica)

	# Configura as músicas para tocarem em loop
	_configurar_loop_musicas()

	print("Sistema de música configurado!")

# --- CONFIGURAR LOOP NAS MÚSICAS ---
func _configurar_loop_musicas():
	# Configura loop para música do menu (MP3)
	if musica_menu is AudioStreamMP3:
		musica_menu.loop = true

	# Configura loop para música do jogo (WAV)
	if musica_jogo is AudioStreamWAV:
		musica_jogo.loop_mode = AudioStreamWAV.LOOP_FORWARD

	# Configura loop para música final (WAV)
	if musica_final is AudioStreamWAV:
		musica_final.loop_mode = AudioStreamWAV.LOOP_FORWARD

# --- TOCAR MÚSICA DO MENU ---
func tocar_musica_menu():
	if audio_player_musica and musica_menu and not audio_mutado:
		# Ajusta volume baseado na configuração
		var volume_final = linear_to_db(volume_musica)
		audio_player_musica.volume_db = volume_final - 10  # -10 para música ficar de fundo

		# Se não estiver tocando, começa a tocar em loop
		if not audio_player_musica.playing:
			audio_player_musica.play()

		print("Música do menu iniciada!")

# --- TOCAR MÚSICA DO JOGO (CASOS) ---
func tocar_musica_jogo():
	if audio_player_musica and musica_jogo and not audio_mutado:
		# Ajusta volume baseado na configuração
		var volume_final = linear_to_db(volume_musica)
		audio_player_musica.volume_db = volume_final - 10  # -10 para música ficar de fundo

		# Troca para a música do jogo se não for a mesma
		if audio_player_musica.stream != musica_jogo:
			audio_player_musica.stop()
			audio_player_musica.stream = musica_jogo
			audio_player_musica.play()
			print("Música do jogo iniciada!")
		elif not audio_player_musica.playing:
			audio_player_musica.play()
			print("Música do jogo iniciada!")

# --- TOCAR MÚSICA DA TELA FINAL ---
func tocar_musica_final():
	if audio_player_musica and musica_final and not audio_mutado:
		# Ajusta volume baseado na configuração
		var volume_final = linear_to_db(volume_musica)
		audio_player_musica.volume_db = volume_final - 10  # -10 para música ficar de fundo

		# Troca para a música final se não for a mesma
		if audio_player_musica.stream != musica_final:
			audio_player_musica.stop()
			audio_player_musica.stream = musica_final
			audio_player_musica.play()
			print("Música da tela final iniciada!")
		elif not audio_player_musica.playing:
			audio_player_musica.play()
			print("Música da tela final iniciada!")

# --- PARAR MÚSICA ---
func parar_musica():
	if audio_player_musica and audio_player_musica.playing:
		audio_player_musica.stop()
		print("Música parada!")

# --- SALVAR CONFIGURAÇÕES ---
func salvar_configuracoes():
	var config = ConfigFile.new()

	# Áudio
	config.set_value("audio", "volume_musica", volume_musica)
	config.set_value("audio", "volume_efeitos", volume_efeitos)
	config.set_value("audio", "audio_mutado", audio_mutado)

	# Interface
	config.set_value("interface", "velocidade_texto", velocidade_texto)
	config.set_value("interface", "mostrar_dicas_automaticas", mostrar_dicas_automaticas)
	config.set_value("interface", "tentativas_para_dica_automatica", tentativas_para_dica_automatica)

	# Acessibilidade
	config.set_value("acessibilidade", "tamanho_fonte", tamanho_fonte)

	# Jogo
	config.set_value("jogo", "mostrar_resultados_sql", mostrar_resultados_sql)
	config.set_value("jogo", "modo_aprendizado", modo_aprendizado)

	var erro = config.save(CONFIG_PATH)
	if erro == OK:
		print("Configurações salvas com sucesso!")
	else:
		printerr("ERRO ao salvar configurações: ", erro)

# --- CARREGAR CONFIGURAÇÕES ---
func carregar_configuracoes():
	var config = ConfigFile.new()
	var erro = config.load(CONFIG_PATH)

	if erro != OK:
		print("Arquivo de configurações não encontrado. Usando valores padrão.")
		salvar_configuracoes()  # Cria arquivo com valores padrão
		return

	# Carrega valores salvos (ou usa padrão se não existir)
	volume_musica = config.get_value("audio", "volume_musica", 0.8)
	volume_efeitos = config.get_value("audio", "volume_efeitos", 0.8)
	audio_mutado = config.get_value("audio", "audio_mutado", false)

	velocidade_texto = config.get_value("interface", "velocidade_texto", 0.02)
	mostrar_dicas_automaticas = config.get_value("interface", "mostrar_dicas_automaticas", false)
	tentativas_para_dica_automatica = config.get_value("interface", "tentativas_para_dica_automatica", 3)

	tamanho_fonte = config.get_value("acessibilidade", "tamanho_fonte", "normal")

	mostrar_resultados_sql = config.get_value("jogo", "mostrar_resultados_sql", true)
	modo_aprendizado = config.get_value("jogo", "modo_aprendizado", true)

	print("Configurações carregadas com sucesso!")
	aplicar_configuracoes()

# --- APLICAR CONFIGURAÇÕES NO JOGO ---
func aplicar_configuracoes():
	# Aplica volumes de áudio
	if audio_mutado:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		# Nota: Implementar buses separados para música e efeitos se necessário

	print("Configurações aplicadas!")

# --- RESETAR PARA PADRÃO ---
func resetar_para_padrao():
	volume_musica = 0.8
	volume_efeitos = 0.8
	audio_mutado = false

	velocidade_texto = 0.02
	mostrar_dicas_automaticas = false
	tentativas_para_dica_automatica = 3

	tamanho_fonte = "normal"

	mostrar_resultados_sql = true
	modo_aprendizado = true

	salvar_configuracoes()
	aplicar_configuracoes()
	print("Configurações resetadas para o padrão!")
