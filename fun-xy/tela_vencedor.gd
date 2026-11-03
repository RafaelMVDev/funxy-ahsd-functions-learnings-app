extends Control # ou CanvasLayer



@onready var label_movimentos = $PanelContainer/VBoxContainer/BoxMovimentos/DisplayMovimentos

func exibir_tela_vitoria(movimentos_finais: int):
	label_movimentos.text = str(movimentos_finais)
	#Fazer a pontuação
	show()
