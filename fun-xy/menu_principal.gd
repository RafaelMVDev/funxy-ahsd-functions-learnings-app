extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	print("O botão de logar foi pressionado com sucesso!")
	
	get_tree().change_scene_to_file("res://login.tscn")
	# Aqui você poderá futuramente mudar para a cena do minigame:
	# get_tree().change_scene_to_file("res://minigame.tscn")


func _on_button_2_pressed() -> void:
	print("O botão de cadastrar foi pressionado com sucesso!")
	
	get_tree().change_scene_to_file("res://cadastro.tscn")
