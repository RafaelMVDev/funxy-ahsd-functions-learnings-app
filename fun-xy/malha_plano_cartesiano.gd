extends Node2D

@export var cor_ponto: Color = Color.RED
@export var raio: float = 3.0
@export var alcance_x: Vector2 = Vector2(-5, 5)
@export var alcance_y: Vector2 = Vector2(-5, 5)
@export var passo_grid: float = 1.0
@export var tamanho_tela: Vector2 

@export var cor_grade: Color = Color(1.0, 1.0, 1.0, 0.4) 
@export var cor_eixos: Color = Color.WHITE      

var ponto_central: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func inicializar_tamanho(tamanho_fundo_plano_cateriano: Vector2):
	tamanho_tela = tamanho_fundo_plano_cateriano
	ponto_central = tamanho_fundo_plano_cateriano/2.0
	print("O ponto central é: ", ponto_central)

func math_para_tela(ponto_math: Vector2) -> Vector2:
	var escala_x = tamanho_tela.x / (alcance_x.y - alcance_x.x)
	var escala_y = tamanho_tela.y / (alcance_y.y - alcance_y.x)
	
	var px = ponto_central.x + (ponto_math.x * escala_x)
	# O eixo Y na tela do Godot é invertido (cresce para baixo),
	# por isso subtraímos para o Y matemático crescer para cima.
	var py = ponto_central.y - (ponto_math.y * escala_y)
	
	return Vector2(px, py)

func desenhar_malha():
	# 1. DESENHAR LINHAS VERTICAIS DA GRADE
	var x = alcance_x.x
	while x <= alcance_x.y:
		var inicio = math_para_tela(Vector2(x, alcance_y.x))
		var fim = math_para_tela(Vector2(x, alcance_y.y))
		draw_line(inicio, fim, cor_grade, 1.0)
		x += passo_grid

	# 2. DESENHAR LINHAS HORIZONTAIS DA GRADE
	var y = alcance_y.x
	while y <= alcance_y.y:
		var inicio = math_para_tela(Vector2(alcance_x.x, y))
		var fim = math_para_tela(Vector2(alcance_x.y, y))
		draw_line(inicio, fim, cor_grade, 1.0)
		y += passo_grid

	# 3. DESENHAR OS EIXOS PRINCIPAIS (X=0 e Y=0) MAIS GROSSOS
	# Eixo X (linha horizontal central)
	var inicio_eixo_x = math_para_tela(Vector2(alcance_x.x, 0))
	var fim_eixo_x = math_para_tela(Vector2(alcance_x.y, 0))
	draw_line(inicio_eixo_x, fim_eixo_x, cor_eixos, 3.0)

	# Eixo Y (linha vertical central)
	var inicio_eixo_y = math_para_tela(Vector2(0, alcance_y.x))
	var fim_eixo_y = math_para_tela(Vector2(0, alcance_y.y))
	draw_line(inicio_eixo_y, fim_eixo_y, cor_eixos, 3.0)

func _draw() -> void:
	desenhar_malha()
	draw_circle(ponto_central, raio, cor_ponto)

	
