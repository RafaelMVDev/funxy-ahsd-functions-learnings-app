extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	# 1. Encontra o centro do PanelContainer
	var centro: Vector2 = size / 2.0
	
	# 2. Desenha o Eixo X (linha horizontal)
	draw_line(Vector2(0, centro.y), Vector2(size.x, centro.y), Color.RED, 2.0)
	
	# 3. Desenha o Eixo Y (linha vertical)
	draw_line(Vector2(centro.x, 0), Vector2(centro.x, size.y), Color.GREEN, 2.0)
	
	# 4. Exemplo de ponto no quadrante negativo (ex: x = -50, y = -50)
	var ponto_cartesiano = Vector2(-50, -50)
	
	# Converte a coordenada para o espaço da tela
	var ponto_tela = centro + Vector2(ponto_cartesiano.x, -ponto_cartesiano.y)
	
	# Desenha um ponto/círculo azul nessa posição
	draw_circle(ponto_tela, 5.0, Color.DODGER_BLUE)

# Recalcula e redesenha se o painel mudar de tamanho
func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
