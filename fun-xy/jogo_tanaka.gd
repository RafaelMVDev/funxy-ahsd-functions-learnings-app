extends Control

@onready var teclado_matematico = $TecladoMatematico
@onready var grafico = $FundoPlanoCartesiano/Grafico

var quantidade_movimentos: int = 0
var funcao_armazenada: String
var dominio_armazenado: String
var linhas_desenhadas: Array[Line2D] = []

func _ready() -> void:
	teclado_matematico.formula_enviada.connect(_on_teclado_formula_enviada)
	teclado_matematico.dominio_enviado.connect(_on_teclado_dominio_enviado)
	teclado_matematico.voltar_movimento.connect(_voltar_movimento)
	
func _on_teclado_formula_enviada(expressao: String):
	print("Pai recebeu a fórmula: ", expressao)
	funcao_armazenada = expressao
	if dominio_armazenado:
		grafico.atualizar_grafico(funcao_armazenada, dominio_armazenado)
		quantidade_movimentos += 1
		print(quantidade_movimentos)
	#grafico.atualizar_grafico(expressao) Usar só quando tiver expressão e domínio
	
func _on_teclado_dominio_enviado(dominio: String):
	dominio_armazenado = dominio
	if funcao_armazenada:
		grafico.atualizar_grafico(funcao_armazenada, dominio_armazenado)
	
func _voltar_movimento():
	if not linhas_desenhadas.is_empty():
		linhas_desenhadas[-1].queue_free()
	
func _process(delta: float) -> void:
	pass
