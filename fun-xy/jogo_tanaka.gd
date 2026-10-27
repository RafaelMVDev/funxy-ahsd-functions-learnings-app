extends Control

@onready var teclado_matematico = $TecladoMatematico
@onready var grafico = $FundoPlanoCartesiano/Grafico

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	teclado_matematico.formula_enviada.connect(_on_teclado_formula_enviada)
	pass # Replace with function body.

func _on_teclado_formula_enviada(expressao: String):
	print("Pai recebeu a fórmula: ", expressao)
	grafico.atualizar_grafico(expressao)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
