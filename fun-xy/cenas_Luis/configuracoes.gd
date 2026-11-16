extends Control

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
	var master_bus_index = AudioServer.get_bus_index("Master")
	var is_muted = AudioServer.is_bus_mute(master_bus_index)
	AudioServer.set_bus_mute(master_bus_index, is_muted)
	botao_som.set_pressed_no_signal(is_muted)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass

func _on_button_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Trilha.tscn")
	pass # Replace with function body.

func _on_button_pressed_conteudo() -> void:
	get_tree().change_scene_to_file("res://Conteudos.tscn")
	pass # Replace with function body.

func _on_button_rank_pressed_ranking() -> void:
	get_tree().change_scene_to_file("res://Ranking.tscn")
	pass # Replace with function body.

func _on_check_button_toggled(toggled_on: bool) -> void:
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus_index, toggled_on)
