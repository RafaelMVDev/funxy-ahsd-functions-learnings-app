extends Button

@export var id_trilha_leitura: int
@export var cena_atual: String

func _ready() -> void:
	pass

func _pressed() -> void:
	DadosGlobais.trilha_leitura_atual = id_trilha_leitura
	DadosGlobais.ultima_cena = cena_atual
	SceneTransition.change_scene("res://materiais_leitura_interface.tscn")

func _process(delta: float) -> void:
	pass
