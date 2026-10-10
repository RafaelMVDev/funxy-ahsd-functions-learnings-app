extends Node2D

@onready var linha: Line2D = $Line2D
@onready var posicao_pai = get_parent().global_position

var comeco_x: float #Posição em pixels do máximo negativo de x

var fim_x: float #Posição em pixels do máximo positivo de x

var limite_y: float #Posição em pixels do máximo nagativo de y

var topo_y: float #Posição em pixels do máximo positivo de y

var ponto_central: Vector2

var unidade: float

var escala_pixel: float

func _ready() -> void:
	var PlanoCartesiano = get_parent()
	var Malha = get_node("../MalhaPlanoCartesiano")
	comeco_x = PlanoCartesiano.origem.x
	fim_x = comeco_x + PlanoCartesiano.size.x
	limite_y = PlanoCartesiano.origem.y + PlanoCartesiano.size.y
	topo_y = PlanoCartesiano.origem.y
	ponto_central = PlanoCartesiano.ponto_central
	escala_pixel = PlanoCartesiano.size.x / (Malha.alcance_x.y - Malha.alcance_x.x)
	desenhar_função()
	print(comeco_x)
	print(fim_x)
	print(limite_y)
	print(topo_y)
	print(ponto_central)
	print(ponto_central)
	print(escala_pixel)
	
func calcular_funcao(valor_x): #Depois precisa do argumento "variável"
	var fx = - 2*escala_pixel + (ponto_central.y + (ponto_central.x - valor_x))
	#var fx = ponto_central.y + (ponto_central.x - valor_x)
	return fx
	
func desenhar_função():
	var x = comeco_x
	var y = 0
	
	while(x<fim_x):
		y = calcular_funcao(x)
		x += 1
		if (y>limite_y) or (y<topo_y):
			continue
		$Line2D.add_point(Vector2(x, y))
	
	
