extends Control # ou CanvasLayer

@onready var label_movimentos = %DisplayMovimentos
@onready var botao_reiniciar = %ResetButton
@onready var botao_home = %HomeButton

signal resetar_partida

func exibir_tela_vitoria(movimentos_finais: int):
	label_movimentos.text = str(movimentos_finais)
	#Fazer a pontuação
	show()
	
func _ready() -> void:
	botao_reiniciar.pressed.connect(reiniciar_partida)
	botao_home.pressed.connect(carregar_home)

func reiniciar_partida() -> void:
	resetar_partida.emit() #Passar os dados da partida? Ao menos o id
	
func carregar_home() -> void:
	get_tree().change_scene_to_file("res://homepage.tscn")
	
