extends VBoxContainer

@export var unidade_atv: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if unidade_atv == DadosGlobais.trilha_leitura_atual:
		visible = true
	else:
		visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
