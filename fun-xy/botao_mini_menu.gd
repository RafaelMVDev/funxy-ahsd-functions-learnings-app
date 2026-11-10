extends Button

@onready var mini_menu = %MiniMenu

func _pressed() -> void:
	mini_menu.visible = !mini_menu.visible
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
