extends Control

@onready var foto_perfil: TextureRect = %FotoPerfil
@onready var seletor_arquivo: FileDialog = %SeletorArquivo

@onready var label_nome: RichTextLabel = %NomeUsuario

var nome = str(Sessao.player['nome'])

@onready var sol = %TextureRectSol
@onready var lua = %TextureRectLua
@onready var texto_sol = %LabelClaro
@onready var texto_lua = %LabelEscuro
@onready var botao_claro = %FundoClaro
@onready var botao_escuro = %FundoEscuro
@onready var botao_som = %BotaoSom

@onready var edicao_nome: PanelContainer = $ConfigScroll/Corpo/EdicaoNome
@onready var input_nome: LineEdit = $ConfigScroll/Corpo/EdicaoNome/VBoxContainer/InputNome
@onready var mensagem_nome: Label =$ConfigScroll/Corpo/EdicaoNome/VBoxContainer/MensagemNome
@onready var salvar_nome: Button = $ConfigScroll/Corpo/EdicaoNome/VBoxContainer/HBoxContainer/SalvarNome
@onready var cancelar_nome: Button = $ConfigScroll/Corpo/EdicaoNome/VBoxContainer/HBoxContainer/CancelarNome
@onready var nome_usuario: RichTextLabel = %NomeUsuario

var salvando_nome: bool = false

#var icon_sol_azul = preload("")
var icon_sol_branco = preload("res://images/icones/aparencia_sol_branco.svg")
var icon_lua_branca = preload("res://images/icones/tema_escuro_lua_branca.svg")
var icon_sol_azul = preload("res://images/icones/tema_claro_sol_azul.svg")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	label_nome.text = nome
	label_nome.visible = true
	edicao_nome.hide()
	salvar_nome.pressed.connect(_salvar_nome)
	cancelar_nome.pressed.connect(_cancelar_edicao_nome)

	if FileAccess.file_exists("user://avatar_usuario.png"):
		var imagem = Image.load_from_file("user://avatar_usuario.png")
		foto_perfil.texture = ImageTexture.create_from_image(imagem)
	if Sessao.player_foto:
		foto_perfil.texture = Sessao.player_foto
	else:
		buscar_foto_perfil()
	var master_bus_index = AudioServer.get_bus_index("Master")
	var is_muted = AudioServer.is_bus_mute(master_bus_index)
	AudioServer.set_bus_mute(master_bus_index, is_muted)
	botao_som.set_pressed_no_signal(is_muted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_button_pressed() -> void:
	"""var estilo_botao_claro: StyleBox = get_theme_stylebox(botao_claro)
	var estilo_botao_escuro: StyleBox = get_theme_stylebox(botao_escuro)
	if estilo_botao_claro.bg_color == Color("e5eefd"):
		sol.icon = icon_sol_branco
		estilo_botao_claro.bg_color = Color("1d3b91")
		#lua,icon = icon_lua_escura
		estilo_botao_escuro.bg_color = Color("e5eefd")
	else:
		sol.icon = icon_sol_azul
		estilo_botao_claro.bg_color = Color("e5eefd")
		#lua,icon = icon_lua_clara
		estilo_botao_escuro.bg_color = Color("1d3b91")"""
	pass


func _on_button_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Trilha.tscn")

func _on_button_pressed_conteudo() -> void:
	get_tree().change_scene_to_file("res://Conteudos.tscn")
	pass # Replace with function body.

func _on_button_rank_pressed_ranking() -> void:
	get_tree().change_scene_to_file("res://Ranking.tscn")
	pass # Replace with function body.
	
func _on_button_pressed_perfil() -> void:
	get_tree().change_scene_to_file("res://Perfil.tscn")

func _on_check_button_toggled(toggled_on: bool) -> void:
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus_index,toggled_on)

func _on_button_deslogar_pressed() -> void:
	Api.sair()
	get_tree().change_scene_to_file("res://cadastro_login.tscn")


func _on_button_trocar_foto_pressed() -> void:
	print("APERTANDO!!!")
	seletor_arquivo.popup_centered(Vector2i(600, 400))

var enviando_foto: bool = false


func _on_seletor_arquivo_file_selected(caminho_arquivo: String) -> void:
	if enviando_foto:
		return

	enviando_foto = true

	# A função abre a imagem, converte para PNG e envia ao backend.
	var salvou: bool = await Api.enviar_foto(caminho_arquivo)

	if salvou:
		print("Foto salva na API!")

		# Atualiza a tela com a imagem que ficou salva no banco.
		await buscar_foto_perfil()
		DadosJogo.carregar_ranking(true)
	else:
		push_warning("Não foi possível salvar a foto.")

	enviando_foto = false


# Busca a foto no backend e coloca no TextureRect.
func buscar_foto_perfil() -> void:
	var textura: ImageTexture = await Api.buscar_foto()
	Sessao.player_foto = textura
	if textura != null:
		foto_perfil.texture = textura
	else:
		# Mantém a imagem atual ou o avatar padrão.
		print("Foto indisponível; mantendo o avatar atual.")


func _on_button_editar_perfil_pressed() -> void:
	# Abre a seção preenchida com o nome atual.
	input_nome.text = str(Sessao.player.get("nome", ""))
	mensagem_nome.hide()
	edicao_nome.show()
	input_nome.grab_focus()
	input_nome.select_all()
	
func _cancelar_edicao_nome() -> void:
	if salvando_nome:
		return

	edicao_nome.hide()
	
func _salvar_nome() -> void:
	if salvando_nome:
		return

	var novo_nome: String = input_nome.text.strip_edges()

	if novo_nome.is_empty():
		mensagem_nome.text = "Digite um nome."
		mensagem_nome.show()
		return

	salvando_nome = true
	salvar_nome.disabled = true
	cancelar_nome.disabled = true
	input_nome.editable = false
	mensagem_nome.text = "Salvando..."
	mensagem_nome.show()

	var resposta: Dictionary = await Api._enviar(
		HTTPClient.METHOD_PATCH,
		"/api/usuario/me/nome",
		JSON.stringify({"nome": novo_nome}),
		Sessao.access_token
	)

	salvando_nome = false
	salvar_nome.disabled = false
	cancelar_nome.disabled = false
	input_nome.editable = true

	if not resposta["ok"]:
		if resposta["codigo"] == 409:
			mensagem_nome.text = "Esse nome já está em uso."
		elif resposta["codigo"] == 401:
			mensagem_nome.text = "Sua sessão expirou. Entre novamente."
		else:
			mensagem_nome.text = "Não foi possível alterar o nome."
		return

	var dados = resposta["dados"]

	if not (dados is Dictionary):
		mensagem_nome.text = "O servidor retornou uma resposta inválida."
		return

	if not (dados.get("nome") is String):
		mensagem_nome.text = "O servidor não retornou o nome atualizado."
		return

	# Só atualiza a sessão e a tela após a confirmação do backend.
	Sessao.player["nome"] = dados["nome"]

	# Mantém o negrito sem interpretar o nome como código BBCode.
	nome_usuario.clear()
	nome_usuario.push_bold()
	nome_usuario.add_text(dados["nome"])
	nome_usuario.pop()

	edicao_nome.hide()
