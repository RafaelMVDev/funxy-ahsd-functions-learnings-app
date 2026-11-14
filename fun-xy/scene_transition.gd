extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func change_scene(target_scene: String) -> void:
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("fade")
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file(target_scene)
	
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	
	# 4. Libera os cliques do mouse novamente
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
