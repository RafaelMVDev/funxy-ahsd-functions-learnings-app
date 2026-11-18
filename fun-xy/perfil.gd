extends Control

@onready var texto_nome = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/NomeUsuario
@onready var texto_xp = $"VBoxContainer/ScrollContainer/VBoxContainer/DadosPerfil/VBoxContainer/Experiência/HBoxContainer/VBoxContainer/ExperienciaText"
@onready var texto_sequencia = $"VBoxContainer/ScrollContainer/VBoxContainer/DadosPerfil/VBoxContainer/Sequência/HBoxContainer/VBoxContainer/SequenciaText"
@onready var texto_pos_ranking = $VBoxContainer/ScrollContainer/VBoxContainer/Ranking
@onready var texto_moedas = %MoedasText
@onready var player_imagem = %PanelFOTO/TextureRect
@onready var player_rank = %RankingPosText
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if Sessao.player_foto:
		player_imagem.texture = Sessao.foto_player 
	texto_nome.text = Sessao.player["nome"]
	texto_xp.text = "XP: " + str(int(Sessao.player["xp"]))
	texto_sequencia.text ="SEQUÊNCIA: " + str(int(Sessao.player["sequencia"]))
	texto_moedas.text = "MOEDAS: " + str(int(Sessao.player["moedas"]))
	player_rank.text = str(DadosGlobais.user_rank) + "º"
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed_configuracao() -> void:
	get_tree().change_scene_to_file("res://Configuracoes.tscn")
	pass # Replace with function body.

func _on_button_pressed_ranking() -> void:
	get_tree().change_scene_to_file("res://Ranking.tscn")
	pass # Replace with function body.

func _on_button_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Trilha.tscn")
	pass # Replace with function body.


func _on_button_pressed_conteudos() -> void:
	get_tree().change_scene_to_file("res://Conteudos.tscn")
	pass # Replace with function body.
