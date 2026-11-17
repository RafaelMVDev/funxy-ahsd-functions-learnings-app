extends Control

@onready var foto_perfil: TextureRect = %FotoPerfil
@onready var seletor_arquivo: FileDialog = %SeletorArquivo

@onready var label_nome: RichTextLabel = %RichTextLabel

var nome = str(Sessao.player['nome'])

@onready var sol = %TextureRectSol
@onready var lua = %TextureRectLua
@onready var texto_sol = %LabelClaro
@onready var texto_lua = %LabelEscuro
@onready var botao_claro = %FundoClaro
@onready var botao_escuro = %FundoEscuro
@onready var botao_som = %BotaoSom

#var icon_sol_azul = preload("")
var icon_sol_branco = preload("res://images/icones/aparencia_sol_branco.svg")
var icon_lua_branca = preload("res://images/icones/tema_escuro_lua_branca.svg")
var icon_sol_azul = preload("res://images/icones/tema_claro_sol_azul.svg")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	label_nome.text = nome
	label_nome.visible = true

	if FileAccess.file_exists("user://avatar_usuario.png"):
		var imagem = Image.load_from_file("user://avatar_usuario.png")
		foto_perfil.texture = ImageTexture.create_from_image(imagem)

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
	get_tree().change_scene_to_file("res://cenas_Luis/Conteudos.tscn")

func _on_button_pressed_conteudo() -> void:
	get_tree().change_scene_to_file("res://Conteudos.tscn")
	pass # Replace with function body.

func _on_button_rank_pressed_ranking() -> void:
	get_tree().change_scene_to_file("res://Ranking.tscn")
	pass # Replace with function body.

func _on_check_button_toggled(toggled_on: bool) -> void:
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus_index,toggled_on)

func _on_button_deslogar_pressed() -> void:
	Api.sair()
	get_tree().change_scene_to_file("res://cadastro_login.tscn")


func _on_button_trocar_foto_pressed() -> void:
	seletor_arquivo.popup_centered(Vector2i(600, 400))

func _on_seletor_arquivo_file_selected(caminho_arquivo: String):
	print("Arquivo selecionado: ", caminho_arquivo)

	# Carrega a imagem direto do caminho selecionado
	var imagem = Image.load_from_file(caminho_arquivo)

	if imagem != null:
		print("Imagem carregada com sucesso! Tamanho: ", imagem.get_size())
		var textura = ImageTexture.create_from_image(imagem)
		foto_perfil.texture = textura

		# Salva localmente para persistir
		imagem.save_png("user://avatar_usuario.png")
	else:
		print("ERRO: Não foi possível ler a imagem nesse caminho.")
