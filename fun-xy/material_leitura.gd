extends Button

@export var id_trilha_leitura: int
@export var cena_atual: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#fazer a verificação do status da atv
	#if id_trilha_leitura in trilhas_atividades_lidas:
	#      aplica estilo diferente no botão
	pass # Replace with function body.

func _pressed() -> void:
	DadosGlobais.trilha_leitura_atual = id_trilha_leitura
	DadosGlobais.ultima_cena = cena_atual
	SceneTransition.change_scene("res://materiais_leitura_interface.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
