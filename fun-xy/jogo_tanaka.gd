extends Control

@onready var menu_vitoria = $tela_vencedor
@onready var teclado_matematico = $TecladoMatematico
@onready var grafico = $FundoPlanoCartesiano/Grafico
@onready var check_funcao = $TecladoMatematico/VisoresTeclado/VisorFuncao/ButtonFuncao
@onready var check_dominio = $TecladoMatematico/VisoresTeclado/VisorDominio/ButtonDominio

var quantidade_movimentos: int = 0
var funcao_armazenada: String
var dominio_armazenado: String
var linhas_desenhadas: Array[Line2D] = []
var linha_desconexa: Array[Line2D] = []

func _ready() -> void:
	teclado_matematico.formula_enviada.connect(_on_teclado_formula_enviada)
	teclado_matematico.dominio_enviado.connect(_on_teclado_dominio_enviado)
	teclado_matematico.voltar_movimento.connect(_voltar_movimento)
	grafico.vitoria.connect(_carregar_menu_vitoria)
	queue_redraw()
	
func _on_teclado_formula_enviada(expressao: String):
	print("Pai recebeu a fórmula: ", expressao)
	check_funcao.visible = true
	funcao_armazenada = expressao
	if dominio_armazenado:
		grafico.atualizar_grafico(funcao_armazenada, dominio_armazenado)
		print(quantidade_movimentos)
		_resetar()
	
func _on_teclado_dominio_enviado(dominio: String):
	if dominio.is_empty():
		dominio_armazenado = "-5<x<5"
	else:
		dominio_armazenado = dominio
	check_dominio.visible = true
	if funcao_armazenada:
		grafico.atualizar_grafico(funcao_armazenada, dominio_armazenado)
		_resetar()
	
func _voltar_movimento():
	if not linhas_desenhadas.is_empty():
		linhas_desenhadas.pop_back().queue_free()
		linhas_desenhadas.back().default_color = Color.GREEN
		
func _resetar():
	funcao_armazenada = ""
	dominio_armazenado = ""
	check_funcao.visible = false
	check_dominio.visible = false

func _carregar_menu_vitoria():
	menu_vitoria.exibir_tela_vitoria(quantidade_movimentos)
	
func _process(delta: float) -> void:
	pass
	
func _draw() -> void:
	draw_circle(Vector2(150,150), 5.0, Color.WHITE)
