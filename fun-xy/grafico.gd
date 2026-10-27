extends Node2D

@onready var linha: Line2D = $Line2D
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

	
func atualizar_grafico(expressao_str: String):
	var lista_de_pontos = calcular_pontos_funcao(expressao_str, alcance_x_min, alcance_x_max, 200)
	
	if not lista_de_pontos.is_empty():
		linha.points = PackedVector2Array(lista_de_pontos)

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

# (A função antiga "desenhar_função" baseada em loop pixel a pixel foi substituída 
# pelo Line2D recebendo os pontos calculados de uma vez só via `atualizar_grafico`).
