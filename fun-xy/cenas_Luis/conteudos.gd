extends Control

func _ready() -> void:
	pass

func _on_texture_button_configuracoes_pressed() -> void:
	get_tree().change_scene_to_file("res://Configuracoes.tscn")


func _on_button_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Trilha.tscn")
	pass # Replace with function body.


func _on_texture_button_pressed_ranking() -> void:
	get_tree().change_scene_to_file("res://Ranking.tscn")
	pass # Replace with function body.


func _on_button_perfil_pressed() -> void:
	get_tree().change_scene_to_file("res://Perfil.tscn")
