extends Control

@onready var texto_nome = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/NomeUsuario
@onready var texto_xp = $"VBoxContainer/ScrollContainer/VBoxContainer/DadosPerfil/VBoxContainer/Experiência/HBoxContainer/VBoxContainer/ExperienciaText"
@onready var texto_sequencia = $"VBoxContainer/ScrollContainer/VBoxContainer/DadosPerfil/VBoxContainer/Sequência/HBoxContainer/VBoxContainer/SequenciaText"
@onready var texto_pos_ranking = $VBoxContainer/ScrollContainer/VBoxContainer/Ranking
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	texto_nome.text = Sessao.player["nome"]
	texto_xp.text = "XP: " + str(int(Sessao.player["xp"]))
	texto_sequencia.text ="SEQUÊNCIA: " + str(int(Sessao.player["sequencia"]))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed_Conteudos() -> void:
	get_tree().change_scene_to_file("res://cenas_Luis/Conteudos.tscn")

func _on_button_pressed_configuracao() -> void:
	get_tree().change_scene_to_file("res://Configuracoes.tscn")
	pass # Replace with function body.

func _on_button_pressed_ranking() -> void:
	get_tree().change_scene_to_file("res://Ranking.tscn")
	pass # Replace with function body.


func _on_button_pressed_conteudos() -> void:
	pass # Replace with function body.
