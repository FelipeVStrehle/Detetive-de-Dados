# area_montagem.gd
extends FlowContainer # Mudado para FlowContainer para quebra de linha automática

# Função chamada pelo Godot para verificar se este nó PODE receber os dados
func _can_drop_data(_at_position, data):
	return typeof(data) == TYPE_STRING

# Função chamada pelo Godot QUANDO os dados são soltos neste nó
func _drop_data(_at_position, data):
	print("Bloco solto na Area_Montagem: ", data)

	# 1. Cria o Label para o bloco
	var bloco_solto = Label.new()
	bloco_solto.text = data

	bloco_solto.mouse_filter = Control.MOUSE_FILTER_STOP

	# 2. Cria e configura o estilo (StyleBox)
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.3, 0.3, 0.3, 0.9) # Cor de fundo
	style_box.border_width_left = 1
	style_box.border_width_top = 1
	style_box.border_width_right = 1
	style_box.border_width_bottom = 1
	style_box.border_color = Color(0.6, 0.6, 0.6) # Cor da borda
	style_box.corner_radius_top_left = 3
	style_box.corner_radius_top_right = 3
	style_box.corner_radius_bottom_right = 3
	style_box.corner_radius_bottom_left = 3
	style_box.content_margin_left = 8      # Padding horizontal
	style_box.content_margin_right = 8
	style_box.content_margin_top = 4       # Padding vertical
	style_box.content_margin_bottom = 4

	# 3. Aplica o estilo ao Label
	bloco_solto.add_theme_stylebox_override("normal", style_box)

	# 4. Ajusta o tamanho mínimo
	bloco_solto.custom_minimum_size = Vector2(0, 35) # Largura automática, Altura mínima 35

	# 5. Centraliza o texto
	bloco_solto.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bloco_solto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# 6. Conecta o sinal para remoção
	# Garante que a conexão use Callable para passar argumentos extras
	bloco_solto.connect("gui_input", Callable(self, "_on_bloco_solto_gui_input").bind(bloco_solto))

	# 7. Adiciona o Label à Area_Montagem
	add_child(bloco_solto)

# Função para lidar com clique no bloco solto
func _on_bloco_solto_gui_input(event: InputEvent, bloco_clicado: Node):
	# Verifica se o evento foi um clique do botão esquerdo do mouse e se foi pressionado
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Garante que o nó clicado ainda é válido antes de tentar removê-lo
		if is_instance_valid(bloco_clicado):
			print("Removendo bloco: ", bloco_clicado.text)
			bloco_clicado.queue_free() # Remove o nó do bloco
