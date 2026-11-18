extends Button

@export var id_trilha_leitura: int
@export var cena_atual: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var id_atv = DadosJogo.buscar_id_leitura(id_trilha_leitura)
	for trilha in Sessao.player_trilhas:
		if trilha["trilhaId"] == id_trilha_leitura:
			for atividade in trilha["atividades"]:
				if atividade["tipo"] == "leitura":
					aplicar_estilo_concluido()
		else:
			pass
			
	pass # Replace with function body.

func aplicar_estilo_concluido() -> void:
	var estilo_botao = StyleBoxFlat.new()
	estilo_botao.set_border_width_all(4)
	estilo_botao.set_corner_radius_all(45)
	estilo_botao.border_color = Color(1.0, 1.0, 1.0, 1.0) 
	estilo_botao.bg_color = Color("418af9") 
	add_theme_stylebox_override("normal", estilo_botao)
	
	var estilo_hover = estilo_botao.duplicate()
	estilo_hover.set_border_width_all(6)
	add_theme_stylebox_override("hover", estilo_hover)
	

func _pressed() -> void:
	DadosGlobais.trilha_leitura_atual = id_trilha_leitura
	DadosGlobais.ultima_cena = cena_atual
	SceneTransition.change_scene("res://materiais_leitura_interface.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
