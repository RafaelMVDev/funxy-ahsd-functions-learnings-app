extends Control

@onready var VisorFuncao: TextEdit = $VisoresTeclado/VisorFuncao
@onready var VisorDominio: TextEdit = $VisoresTeclado/VisorDominio
@onready var vbox: VBoxContainer = $VisoresTeclado/VBoxContainer

func _ready() -> void:
	for linha in vbox.get_children():
		if linha is HBoxContainer:
			for botao in linha.get_children():
				if botao is Button:
					botao.pressed.connect(_on_botao_pressionado.bind(botao))

func _on_botao_pressionado(botao_clicado: Button) -> void:
	var texto_do_botao: String = botao_clicado.text

	if texto_do_botao == "del":
		VisorFuncao.text = "" 
	elif texto_do_botao == "⌫":
		_apagar_com_backspace()
	elif texto_do_botao == "ok":
		_enviar_expressao() # Executa a conta
	else:
		VisorFuncao.text += texto_do_botao # Adiciona o número ou operador no visor

func _apagar_com_backspace():
	#text = text.erase(posicao_cursor - 1, 1)
	#a posição eu tenho q acesar por caret column
	pass

func _enviar_expressao() -> void:
	# formata a expressão
	# envia para o plano cartesiano calcular (x,y) e exibir
	pass
