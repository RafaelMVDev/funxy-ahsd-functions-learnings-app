extends Control

@onready var VisorFuncao: TextEdit = $VisoresTeclado/VisorFuncao
@onready var VisorDominio: TextEdit = $VisoresTeclado/VisorDominio
@onready var vbox: VBoxContainer = $VisoresTeclado/VBoxContainer

signal formula_enviada(expressao: String)

var visor_ativo: TextEdit = null

func _ready() -> void:
	VisorFuncao.focus_entered.connect(_on_visor_focado.bind(VisorFuncao))
	VisorDominio.focus_entered.connect(_on_visor_focado.bind(VisorDominio))
	for linha in vbox.get_children():
		if linha is HBoxContainer:
			for botao in linha.get_children():
				if botao is Button:
					botao.pressed.connect(_on_botao_pressionado.bind(botao))

func _on_visor_focado(node: TextEdit):
	if visor_ativo != null and is_instance_valid(visor_ativo):
		_estilo_visor(visor_ativo, "normal")
	visor_ativo = node
	if visor_ativo != null:
		_estilo_visor(visor_ativo, "focado")
	
func _estilo_visor(node: TextEdit, estilo: String):
	var stylebox_visor = node.get_theme_stylebox("normal")
	var estilo_modificado = stylebox_visor.duplicate()
	
	if estilo == "normal":
		estilo_modificado.border_width_left = 0
		estilo_modificado.border_width_right = 0
		estilo_modificado.border_width_top = 0
		estilo_modificado.border_width_bottom = 0
	else:
		estilo_modificado.border_width_left = 2
		estilo_modificado.border_width_right = 2
		estilo_modificado.border_width_top = 2
		estilo_modificado.border_width_bottom = 2
		estilo_modificado.border_color = Color("#ffffff") 
	node.add_theme_stylebox_override("normal", estilo_modificado)

func _on_botao_pressionado(botao_clicado: Button) -> void:
	var texto_do_botao: String = botao_clicado.text

	if texto_do_botao == "del":
		visor_ativo.text = "" 
	elif texto_do_botao == "⌫":
		print("reconhece o backspace")
		_apagar_com_backspace()
	elif texto_do_botao == "ok":
		emit_signal("formula_enviada", visor_ativo.text) # Executa a conta
	else:
		_inserir_texto_no_cursor(texto_do_botao) # Adiciona o número ou operador no visor

func _apagar_com_backspace():
	var coluna: int = visor_ativo.get_caret_column()

	if coluna > 0:
		var texto: String = visor_ativo.text
		visor_ativo.text = texto.substr(0, coluna - 1) + texto.substr(coluna)
		visor_ativo.set_caret_column(coluna - 1)

func _inserir_texto_no_cursor(texto_do_botao: String):
	if visor_ativo != null:
		var coluna: int = visor_ativo.get_caret_column()
		var texto_atual: String = visor_ativo.text
		visor_ativo.text = texto_atual.substr(0, coluna) + texto_do_botao + texto_atual.substr(coluna)
		visor_ativo.set_caret_column(coluna + texto_do_botao.length())
		
