extends Node2D

@onready var posicao_pai = get_parent().global_position

var comeco_x: float 
var fim_x: float 
var limite_y: float 
var topo_y: float 
var ponto_central: Vector2
var escala_pixel: float
var alcance_x_min: float = -5.0
var alcance_x_max: float = 5.0

func _ready() -> void:
	var PlanoCartesiano = get_parent()
	var Malha = get_node("../MalhaPlanoCartesiano")
	comeco_x = PlanoCartesiano.origem.x
	fim_x = comeco_x + PlanoCartesiano.size.x
	limite_y = PlanoCartesiano.origem.y + PlanoCartesiano.size.y
	topo_y = PlanoCartesiano.origem.y
	ponto_central = PlanoCartesiano.ponto_central
	
	if Malha:
		alcance_x_min = Malha.alcance_x.x
		alcance_x_max = Malha.alcance_x.y
		escala_pixel = PlanoCartesiano.size.x / (alcance_x_max - alcance_x_min)
	else:
		escala_pixel = 30.0
	
func atualizar_grafico(expressao_str: String, dominio_str: String):
	var dominio = dominio_str
	var x_min: float = alcance_x_min
	var x_max: float = alcance_x_max
	
	if "<" in dominio or "<=" in dominio:
		var partes = dominio.split("x")
		if partes.size() == 2:
			var min_str = partes[0].replace("<=", "").replace("<", "")
			if min_str.is_valid_float():
				x_min = min_str.to_float()
				
			var max_str = partes[1].replace("<=", "").replace("<", "")
			if max_str.is_valid_float():
				x_max = max_str.to_float()
				
	elif ">" in dominio or ">=" in dominio:
		var partes = dominio.split("x")
		if partes.size() == 2:
			var min_str = partes[1].replace(">=", "").replace(">", "")
			if min_str.is_valid_float():
				x_min = min_str.to_float()
				x_max = x_min + 20.0 
	
	var lista_de_pontos = calcular_pontos_funcao(expressao_str, x_min, x_max, 600) 
	
	if not lista_de_pontos.is_empty():
		var nova_linha = Line2D.new()
		nova_linha.points = PackedVector2Array(lista_de_pontos)
		nova_linha.width = 2.0
		add_child(nova_linha)
		get_parent().get_parent().linhas_desenhadas.append(nova_linha)

func calcular_pontos_funcao(expressao_str: String, x_min: float, x_max: float, passos: int) -> Array[Vector2]:
	var pontos: Array[Vector2] = []
	var expr = Expression.new()
	
	var erro = expr.parse(expressao_str, ["x"])
	if erro != OK:
		print("Erro na expressão matemática: ", expr.get_error_text())
		return pontos

	var passo_x = (x_max - x_min) / passos
	for i in range(passos + 1):
		var x_matematico = x_min + (i * passo_x)
		var y_matematico = expr.execute([x_matematico])

		var pixel_x = ponto_central.x + (x_matematico * escala_pixel)
		var pixel_y = ponto_central.y - (y_matematico * escala_pixel) 
		
		if pixel_y >= topo_y and pixel_y <= limite_y:
			pontos.append(Vector2(pixel_x, pixel_y))
		
	return pontos
