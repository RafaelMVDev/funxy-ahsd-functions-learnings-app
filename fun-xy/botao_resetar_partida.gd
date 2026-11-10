extends Button

signal reiniciar_partida

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _pressed() -> void:
	emit_signal("reiniciar_partida")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
