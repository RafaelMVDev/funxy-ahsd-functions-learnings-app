extends Control

@onready var label_user_atual = %LabelNomeUserAtuall
@onready var label_xp_atual = %LabelXpUserAtual
@onready var label_posicao_atual = %LabelPosicaoUserAtual
@onready var rank = %Rank
@onready var painel_player = %ContainerPlayer

var posicao_player

func _ready() -> void:
	
	label_user_atual.text = Sessao.player["nome"]
	if not Sessao.player["xp"]:
		label_xp_atual.text = "0xp"
	else:
		label_xp_atual.text = str(int(Sessao.player["xp"])) + "xp"
	var usuarios = DadosJogo.ranking_xp
	for usuario in usuarios:
		if usuario["usuarioId"] == Sessao.player["id"]:
			posicao_player = usuario["posicao"]
	
	label_posicao_atual.text = str(int(posicao_player))+"º"
	
	var estilo_painel_player = painel_player.get_theme_stylebox("panel")
	if estilo_painel_player is StyleBoxFlat:
		var estilo_unico = estilo_painel_player.duplicate()
	
		if posicao_player == 1:
			estilo_unico.bg_color = Color("f7d500ff")
		elif posicao_player == 2:
			estilo_unico.bg_color = Color("f78d00ff")
		elif posicao_player == 3:
			estilo_unico.bg_color = Color("f76700ff")
		else:
			estilo_unico.bg_color = Color(0.8, 0.8, 0.8) # Cinza claro
		
		painel_player.add_theme_stylebox_override("panel", estilo_unico)
		
	gerar_ranking(usuarios, rank)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func gerar_ranking(lista_usuarios: Array, vbox_pai: VBoxContainer):
	for jogador in lista_usuarios:
		var posicao = jogador["posicao"]
		
		var panel_user = PanelContainer.new()
		panel_user.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		panel_user.custom_minimum_size.y = 55
		
		var style_panel = StyleBoxFlat.new()
		
		style_panel.bg_color = Color("0f2968")
		style_panel.content_margin_left = 15
		style_panel.content_margin_right = 15
		panel_user.add_theme_stylebox_override("panel", style_panel)
		
		var hbox = HBoxContainer.new()
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_theme_constant_override("separation", 9)
		panel_user.add_child(hbox)
		
		var panel_foto = PanelContainer.new()
		panel_foto.custom_minimum_size = Vector2(45, 45)
		panel_foto.custom_maximum_size = Vector2(45, 45)
		panel_foto.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		var style_foto = StyleBoxFlat.new()
		if posicao == 1:
			style_foto.bg_color = Color("f7d500ff")
		elif posicao == 2:
			style_foto.bg_color = Color("f78d00ff")
		elif posicao == 3:
			style_foto.bg_color = Color("f76700ff")
		else:
			style_foto.bg_color = Color(0.8, 0.8, 0.8) # Cinza claro
		style_foto.corner_radius_top_left = 100
		style_foto.corner_radius_top_right = 100
		style_foto.corner_radius_bottom_left = 100
		style_foto.corner_radius_bottom_right = 100
		panel_foto.add_theme_stylebox_override("panel", style_foto)
		hbox.add_child(panel_foto)
		
		var foto = TextureRect.new()
		foto.custom_minimum_size = Vector2(40, 40)
		foto.texture = load("res://images/icones_luis/Foto_de_Perfil.png")
		foto.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		foto.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		foto.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		foto.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		panel_foto.add_child(foto)
		
		
		
		var vbox_textos = VBoxContainer.new()
		vbox_textos.add_theme_constant_override("separation", -6)
		vbox_textos.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox_textos.size_flags_horizontal = Control.SIZE_EXPAND_FILL # Expande para empurrar o ranking para a direita
		hbox.add_child(vbox_textos)
		
		var label_nome = Label.new()
		label_nome.text = str(jogador["nome"])
		
		vbox_textos.add_child(label_nome)
		
		var label_xp = Label.new()
		if jogador["xp"]:
			label_xp.text = str(int(jogador["xp"])) + "xp"
		else: 
			label_xp.text = "0"
		vbox_textos.add_child(label_xp)
		
		var label_posicao = Label.new()
		label_posicao.text = str(int(posicao)) + "º"
		label_posicao.vertical_alignment = VERTICAL_ALIGNMENT_CENTER 
		hbox.add_child(label_posicao)
		
		vbox_pai.add_child(panel_user)

func _on_button_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Trilha.tscn")
	pass # Replace with function body.


func _on_texture_button_pressed_conteudos() -> void:
	get_tree().change_scene_to_file("res://Conteudos.tscn")
	pass # Replace with function body.


func _on_texture_button_pressed_config() -> void:
	get_tree().change_scene_to_file("res://Configuracoes.tscn")
	pass # Replace with function body.


func _on_button_perfil_pressed() -> void:
	get_tree().change_scene_to_file("res://Perfil.tscn")
