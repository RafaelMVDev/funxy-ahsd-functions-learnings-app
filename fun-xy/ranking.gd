extends Control

@onready var label_user_atual = %LabelNomeUserAtuall
@onready var label_xp_atual = %LabelXpUserAtual
@onready var label_posicao_atual = %LabelPosicaoUserAtual
@onready var rank = %Rank
@onready var painel_player = $PanelContainer2/HBoxContainer/ContainerPlayer
@onready var foto_ranking = $PanelContainer2/HBoxContainer/ContainerPlayer/FotoRanking
var posicao_player

func _ready() -> void:
	
	label_user_atual.text = Sessao.player["nome"]
	if not Sessao.player["xp"]:
		label_xp_atual.text = "0xp"
	else:
		label_xp_atual.text = str(int(Sessao.player["xp"])) + "xp"
	DadosJogo.carregar_ranking()
	var usuarios = DadosJogo.ranking_xp
	for usuario in usuarios:
		if usuario["usuarioId"] == Sessao.player["id"]:
			posicao_player = usuario["posicao"]
	
	if Sessao.player_foto:
		foto_ranking.texture = Sessao.player_foto
	DadosGlobais.user_rank = posicao_player
	
	label_posicao_atual.text = str(int(posicao_player))+"º"
	
	var estilo_painel_player = painel_player.get_theme_stylebox("panel")
	if estilo_painel_player is StyleBoxFlat:
		var estilo_unico = estilo_painel_player.duplicate()
	
		if posicao_player == 1:
			estilo_unico.bg_color = Color("f5d67aff")
		elif posicao_player == 2:
			estilo_unico.bg_color = Color("c4d7eaff")
		elif posicao_player == 3:
			estilo_unico.bg_color = Color("e9bb97ff")
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
		panel_user.custom_minimum_size.y = 68
		
		var style_panel = StyleBoxFlat.new()
		
		style_panel.bg_color = Color("ffffff")
		# Acabamento compartilhado com os painéis das cenas.
		style_panel.set_corner_radius_all(16)
		style_panel.set_border_width_all(1)
		style_panel.border_color = Color("e1e8f0")
		style_panel.content_margin_top = 8
		style_panel.content_margin_bottom = 8
		style_panel.content_margin_left = 12
		style_panel.content_margin_right = 12
		panel_user.add_theme_stylebox_override("panel", style_panel)
		
		var hbox = HBoxContainer.new()
		hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		hbox.add_theme_constant_override("separation", 9)
		panel_user.add_child(hbox)
		
		var panel_foto = PanelContainer.new()
		panel_foto.custom_minimum_size = Vector2(50, 50)

		# Usa o desenho arredondado do painel como máscara para os filhos.
		panel_foto.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW

		# Remove margens internas para a foto preencher o painel.
		
		panel_foto.propagate_maximum_size = true
		# O tamanho vem do conteúdo e do alinhamento, sem depender de um limite máximo.
		panel_foto.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		panel_foto.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		
		var style_foto = StyleBoxFlat.new()
		if posicao == 1:
			style_foto.bg_color = Color("f5d67aff")
		elif posicao == 2:
			style_foto.bg_color = Color("c4d7eaff")
		elif posicao == 3:
			style_foto.bg_color = Color("e9bb97ff")
		else:
			style_foto.bg_color = Color(0.8, 0.8, 0.8) # Cinza claro
		style_foto.content_margin_left = 2
		style_foto.content_margin_right = 2
		style_foto.content_margin_top = 2
		style_foto.content_margin_bottom = 2
		style_foto.set_corner_radius_all(25)
		panel_foto.add_theme_stylebox_override("panel", style_foto)
		panel_foto.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
		panel_foto.propagate_maximum_size = true
		hbox.add_child(panel_foto)
		
		var foto = TextureRect.new()
		foto.custom_minimum_size = Vector2(50,50)
		foto.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		foto.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		var id_jogador_str = str(int(jogador.usuarioId))
		print("rodando!")
		var foto_bytes = DadosJogo.ranking_fotos.get(id_jogador_str,false)
		if foto_bytes:
			var imagem := Image.new()

			if imagem.load_png_from_buffer(foto_bytes) == OK:
				push_warning("Válido foto")
				var textura = ImageTexture.create_from_image(imagem)
				foto.texture = textura
		else:
			foto.texture = load("res://ui/avatar.svg")
	
		foto.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		#foto.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		#foto.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		panel_foto.add_child(foto)
		
		
		
		var vbox_textos = VBoxContainer.new()
		vbox_textos.add_theme_constant_override("separation", 3)
		vbox_textos.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox_textos.size_flags_horizontal = Control.SIZE_EXPAND_FILL # Expande para empurrar o ranking para a direita
		hbox.add_child(vbox_textos)
		
		var label_nome = Label.new()
		if jogador["nome"] == "Lia Funxy":
			label_nome.text = "LeviAlves"
		else:
			label_nome.text = str(jogador["nome"])
		label_nome.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		label_nome.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		vbox_textos.add_child(label_nome)
		
		var label_xp = Label.new()
		label_xp.add_theme_color_override("font_color", Color("576b84"))
		label_xp.add_theme_font_size_override("font_size", 14)
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
