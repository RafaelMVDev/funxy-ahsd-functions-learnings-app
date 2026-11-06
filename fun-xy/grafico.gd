extends Node2D

@onready var posicao_pai = get_parent().global_position
@onready var jogo = get_parent().get_parent()
@onready var funcoes_exibidas_1 = $PainelFuncoes/FuncoesListadas
@onready var funcoes_exibidas = get_node("../../PainelFuncoes/FuncoesListadas")
@onready var mensagem = get_node("../../TecladoMatematico/VisoresTeclado/Mensagem")
@onready var check_funcao = %ButtonFuncao
@onready var check_dominio = %ButtonDominio

signal vitoria()

var dados_fase_api = [ #Simulação
	{ "tipo": "inicio", "x": -5.0, "y": -5.0, "largura": 0.4, "altura": 0.4 },
	{ "tipo": "fim", "x": 5.0, "y": 3.0, "largura": 0.4, "altura": 0.4 },
	{ "tipo": "obstaculo", "x": 2.0, "y": 3.0, "largura": 1.0, "altura": 1.5 },
	{ "tipo": "obstaculo", "x": -3.0, "y": -1.0, "largura": 0.8, "altura": 2.0 }
]

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
	carregar_fase(dados_fase_api)

func carregar_fase(colisoes_dados: Array):
	for dados in colisoes_dados:
		var colisor = Area2D.new()
		var forma_retangulo = RectangleShape2D.new()
		var visual = ColorRect.new()
			#Adicionar outros shapes existem
		forma_retangulo.size = Vector2(dados.largura * escala_pixel, dados.altura * escala_pixel)
		visual.size = forma_retangulo.size
		visual.position = -visual.size / 2.0

		var pixel_x = ponto_central.x + (dados.x * escala_pixel)
		var pixel_y = ponto_central.y - (dados.y * escala_pixel)

		colisor.position = Vector2(pixel_x, pixel_y)

		if dados.tipo == "inicio":
			visual.color = Color.YELLOW
			colisor.add_to_group("inicio")

		elif dados.tipo == "fim":
			visual.color = Color.GREEN
			colisor.add_to_group("fim")

		else:
			visual.color = Color.RED 
			colisor.add_to_group("obstaculos")

		colisor.add_child(visual)
		add_child(colisor)

func definir_dominio(dominio: String) -> Array:
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
				
	return [x_min, x_max]

func atualizar_grafico(expressao_str: String, dominio_str: String):
	jogo.quantidade_movimentos += 1
	jogo.lista_funcoes.append(expressao_str)
	check_funcao.visible = false
	check_dominio.visible = false
	mensagem.text = ""
	
	var dominio = dominio_str
	var primeiro_ponto = false
	
	var limites = definir_dominio(dominio_str)
	var x_min: float = limites[0]
	var x_max: float = limites[1]
	var acertou_comeco = false

	var lista_de_pontos = calcular_pontos_funcao(expressao_str, x_min, x_max, 800)
	
	if not lista_de_pontos.is_empty():
		var nova_linha = Line2D.new()
		nova_linha.points = PackedVector2Array(lista_de_pontos)
		nova_linha.width = 3.0
	
		if not jogo.linha_desconexa.is_empty():
			jogo.linha_desconexa.pop_back().queue_free()
		
		if verificar_cruzamento(lista_de_pontos):
			var acertou_inicio = false
			var acertou_fim = false
			
			for ponto in lista_de_pontos:
				if verificar_colisao(ponto, "inicio"):
					acertou_inicio = true
				if verificar_colisao(ponto, "fim"):
					acertou_fim = true

			if jogo.linhas_desenhadas.is_empty():
				if acertou_inicio:
					nova_linha.default_color = Color.GREEN
					jogo.linhas_desenhadas.append(nova_linha)
				else:
					nova_linha.default_color = Color.ORANGE
					jogo.linha_desconexa.append(nova_linha)
					mensagem.text = "Não acertou o ponto inicial"
			else:
				nova_linha.default_color = Color.GREEN
				jogo.linhas_desenhadas.back().default_color = Color.WHITE 
				jogo.linhas_desenhadas.append(nova_linha)
			
			if acertou_fim and nova_linha in jogo.linhas_desenhadas:
				emit_signal("vitoria")
				
		else:
			nova_linha.default_color = Color.ORANGE
			jogo.linha_desconexa.append(nova_linha)
			mensagem.text = "A linha não tem continuidade"
		
		add_child(nova_linha)
		funcoes_exibidas.exibir_funcoes(expressao_str)
		nova_linha.add_to_group("linhas")

func calcular_pontos_funcao(expressao_str: String, x_min: float, x_max: float, passos: int) -> Array[Vector2]:
	var pontos: Array[Vector2] = []
	var expr = Expression.new()
	var ponto: Vector2
	var passo_x = (x_max - x_min) / passos

	var erro = expr.parse(expressao_str, ["x"])
	if erro != OK:
		mensagem.text = "Erro na expressão matemática"
		return pontos

	for i in range(passos + 1):
		var x_matematico = x_min + (i * passo_x)
		var y_matematico = expr.execute([x_matematico])
		var pixel_x = ponto_central.x + (x_matematico * escala_pixel)
		var pixel_y = ponto_central.y - (y_matematico * escala_pixel)

		ponto = Vector2(pixel_x, pixel_y)

		if pixel_y >= topo_y and pixel_y <= limite_y:
			if verificar_colisao(ponto, "obstaculos"):
				return pontos
			pontos.append(ponto)
	return pontos

func verificar_cruzamento(novos_pontos: Array[Vector2]) -> bool:
	if jogo.linhas_desenhadas.is_empty():
		return true

	var tolerancia = 3
	var linha_antiga = jogo.linhas_desenhadas.back()
	var pontos_antigos = linha_antiga.points
	
	for ponto_novo in novos_pontos:
		for ponto_antigo in pontos_antigos:
			if ponto_novo.distance_to(ponto_antigo) <= tolerancia:
				return true
	return false

func verificar_colisao(ponto: Vector2, tipo: String) -> bool:
	var colisores = get_tree().get_nodes_in_group(tipo)

	for colisor in colisores:
		var visual = colisor.get_child(0)
		if visual and visual is ColorRect:

			var ponto_superior_esquerdo = colisor.position + visual.position
			var rect_colisor = Rect2(ponto_superior_esquerdo, visual.size)
			if rect_colisor.has_point(ponto):
				return true

	return false
