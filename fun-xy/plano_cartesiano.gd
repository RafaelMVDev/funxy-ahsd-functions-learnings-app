extends Node2D

@export var posicao_pai_na_tela: Vector2
# Tamanho da área do plano na tela (em pixels)
@export var tamanho_tela: Vector2 = Vector2(300,300)
# Limites da matemática (de -10 a 10 no eixo X e no eixo Y)
@export var alcance_x: Vector2 = Vector2(-10, 10)
@export var alcance_y: Vector2 = Vector2(-10, 10)

# De quanto em quanto as linhas da grade vão aparecer (ex: de 1 em 1 unidade)
@export var passo_grid: float = 1.0

# Cores
@export var cor_grade: Color = Color(0.4, 0.4, 0.4, 0.4) # Cinza semi-transparente
@export var cor_eixos: Color = Color.BLACK              # Branco para os eixos centrais

# Ponto (0,0) da tela onde fica a origem matemática
var centro_tela: Vector2


func _ready() -> void:
	# Centraliza o ponto (0,0) no meio do tamanho configurado
	centro_tela = tamanho_tela / 2.0
	
	# Pede para o Godot chamar a função _draw()
	queue_redraw()

# Converter coordenada matemática (x, y) -> pixels da tela
func math_para_tela(ponto_math: Vector2) -> Vector2:
	var escala_x = tamanho_tela.x / (alcance_x.y - alcance_x.x)
	var escala_y = tamanho_tela.y / (alcance_y.y - alcance_y.x)
	
	var px = centro_tela.x + (ponto_math.x * escala_x)
	# O eixo Y na tela do Godot é invertido (cresce para baixo),
	# por isso subtraímos para o Y matemático crescer para cima.
	var py = centro_tela.y - (ponto_math.y * escala_y)
	
	return Vector2(px, py)

# Função nativa do Godot para desenhar elementos 2D simples
func _draw() -> void:
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
