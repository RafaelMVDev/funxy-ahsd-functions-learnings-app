extends Control

@onready var VisorFuncao: LineEdit = %VisorFuncao
@onready var VisorDominio: LineEdit = %VisorDominio
@onready var vboxFuncao: VBoxContainer = $VisoresTeclado/VBoxContainerFuncao
@onready var vboxDominio: VBoxContainer = $VisoresTeclado/VBoxContainerDominio
@onready var check_funcao: Button = %ButtonFuncao
@onready var check_dominio: Button = %ButtonDominio

signal voltar_movimento()
signal formula_enviada(expressao: String)
signal dominio_enviado(dominio: String)

var visor_ativo: LineEdit = null

func _ready() -> void:
	VisorFuncao.focus_entered.connect(_on_visor_funcao)
	VisorDominio.focus_entered.connect(_on_visor_dominio)
	for box in vboxFuncao.get_children():
		if box is VBoxContainer:
			for linha in box.get_children():
				if linha is HBoxContainer:
					for botao in linha.get_children():
						if botao is Button:
							botao.pressed.connect(_on_botao_pressionado.bind(botao))
	for linha in vboxDominio.get_children():
		if linha is HBoxContainer:
			for botao in linha.get_children():
				if botao is Button:
					botao.pressed.connect(_on_botao_pressionado.bind(botao))

func _on_visor_funcao():
	_on_visor_focado(VisorFuncao)
	vboxFuncao.visible = true
	vboxDominio.visible = false
	
func _on_visor_dominio():
	_on_visor_focado(VisorDominio)
	vboxFuncao.visible = false
	vboxDominio.visible = true

func _on_visor_focado(node: LineEdit):
	if visor_ativo != null and is_instance_valid(visor_ativo):
		_estilo_visor(visor_ativo, "normal")
	visor_ativo = node
	if visor_ativo != null:
		_estilo_visor(visor_ativo, "focado")
	
func _estilo_visor(node: LineEdit, estilo: String):
	var stylebox_visor = node.get_theme_stylebox("normal")
	var estilo_modificado = stylebox_visor.duplicate()
	
	if estilo == "normal":
		estilo_modificado.border_color = Color("#0f3f73")
		estilo_modificado.bg_color = Color("2c66b7")
	else:
		estilo_modificado.border_color = Color("05203fff") 
		estilo_modificado.bg_color = Color("0d3766ff")
	node.add_theme_stylebox_override("normal", estilo_modificado)

func _on_botao_pressionado(botao_clicado: Button) -> void:
	var texto_do_botao: String = botao_clicado.text
	if texto_do_botao == "⭢":
		vboxFuncao.get_child(0).visible = false
		vboxFuncao.get_child(1).visible = true
	elif texto_do_botao == "⭠":
		vboxFuncao.get_child(0).visible = true
		vboxFuncao.get_child(1).visible = false
	else:
		if visor_ativo:
			if visor_ativo.get_child(0).visible == true:
				visor_ativo.get_child(0).visible = false
		
			if visor_ativo == VisorFuncao:
				get_parent().funcao_armazenada = ""
			else:
				get_parent().dominio_armazenado = ""

			if texto_do_botao == "del":
				visor_ativo.text = "" 
			elif texto_do_botao == "⌫":
				visor_ativo.get_child(0).visible = false
				_apagar_com_backspace()
			elif texto_do_botao == "↩":
				emit_signal("voltar_movimento")
			elif texto_do_botao == "ok":
				if visor_ativo == VisorFuncao:
					if visor_ativo.text:
						check_funcao.visible = true
						emit_signal("formula_enviada", visor_ativo.text) 
				else:
					check_dominio.visible = true
					emit_signal("dominio_enviado", visor_ativo.text)
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
		
