extends PanelContainer

var ponto_central: Vector2 = Vector2(size/2)
var tamanho: Vector2 = Vector2(size)
var origem: Vector2 = Vector2.ZERO

func _ready() -> void:
	print("Tamanho: ", tamanho)

func _process(_delta: float) -> void:
	pass
