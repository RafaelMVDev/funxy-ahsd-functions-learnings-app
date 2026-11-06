extends Control # ou CanvasLayer

@onready var label_movimentos = $PanelContainer/VBoxContainer/BoxMovimentos/DisplayMovimentos
@onready var botao_reiniciar = %ResetButton

signal resetar_partida

func exibir_tela_vitoria(movimentos_finais: int):
	label_movimentos.text = str(movimentos_finais)
	#Fazer a pontuação
	show()
	
func _ready() -> void:
	botao_reiniciar.pressed.connect(reiniciar_partida)

func reiniciar_partida() -> void:
	resetar_partida.emit() #Passar os dados da partida? Ao menos o id
	
	
	
