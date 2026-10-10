extends PanelContainer

var ponto_central: Vector2 = Vector2(size/2)
var tamanho: Vector2 = Vector2(size)
var origem: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Tamanho: ", tamanho)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
