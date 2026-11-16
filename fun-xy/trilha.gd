extends Control

@onready var label_porcentagem: Label = %LabelPorcentagemProgresso
@onready var barra_progresso: ProgressBar = %ProgressBar2

func _ready() -> void:
	progresso_visual()
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func progresso_visual() -> void:
	var total_atividades = contar_total_atividades(DadosJogo.trilhas)
	var total_concluidas = contar_atividades_concluidas(Sessao.player_trilhas)
	
	var porcentagem: float = (float(total_concluidas) / float(total_atividades)) * 100.0
	porcentagem = snapped(porcentagem, 0.01)
	
	label_porcentagem.text = str(porcentagem) + "%"
	barra_progresso.value = porcentagem
	
	
func contar_total_atividades(dados: Array) -> int:
	var total: int = 0
	
	for trilha in dados:
		if trilha.has("atividades"):
			total += trilha["atividades"].size()
			
	return total

func contar_atividades_concluidas(dados: Array) -> int:
	var total_concluidas: int = 0
	
	for trilha in dados:
		if trilha.has("atividades"):
			for atividade in trilha["atividades"]:
				if atividade.has("tentativas"):
					for tentativa in atividade["tentativas"]:if tentativa.has("status") and tentativa["status"] == true:
							total_concluidas += 1
							break 
							
	return total_concluidas

func _on_texture_button_contaudos_pressed() -> void:
	get_tree().change_scene_to_file("res://Conteudos.tscn")

func _on_texture_button_pressed_config() -> void:
	get_tree().change_scene_to_file("res://Configuracoes.tscn")

func _on_texture_button_pressed_rank() -> void:
	get_tree().change_scene_to_file("res://Ranking.tscn")
