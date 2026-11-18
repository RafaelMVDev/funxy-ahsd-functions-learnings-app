extends Control

@onready var label_jogo: Label = %LabelProgressoJogo
@onready var barra_jogo: ProgressBar = %ProgressBarJogosBarJogo
@onready var label_leitura: Label = %LabelProgressoAtv
@onready var barra_leitura: ProgressBar = %ProgressBarMateriais

func _ready() -> void:
	pass
	
func barra_progresso_visual() -> void:
	var total_atividades_jogo = contar_total_atividades_praticas(DadosJogo.trilhas)
	var total_concluidas_jogo = contar_atividades_concluidas_jogo(Sessao.player_trilhas)
	var total_atividades_leitura = contar_total_atividades_leitura(DadosJogo.trilhas)
	var total_concluidas_leitura = contar_atividades_concluidas_leitura(Sessao.player_trilhas)
	
	var porcentagem_jogo: float = (float(total_concluidas_jogo) / float(total_atividades_jogo)) * 100.0
	porcentagem_jogo = snapped(porcentagem_jogo, 0.01)
	
	label_jogo.text = str(porcentagem_jogo) + "%"
	barra_jogo.value = porcentagem_jogo
	
	var porcentagem_leitura: float = (float(total_concluidas_leitura) / float(total_atividades_leitura)) * 100.0
	porcentagem_leitura = snapped(porcentagem_leitura, 0.01)
	
	label_leitura.text = snapped(porcentagem_leitura, 0.01)
	barra_leitura.value = porcentagem_leitura
	

func contar_total_atividades_praticas(dados: Array) -> int:
	var counter: int
	
	for trilha in dados:
		if trilha.has("atividades"):
			for atv in trilha["atividades"]:
				if atv["tipo"] == "pratica":
					counter += 1			
	return counter
	
func contar_total_atividades_leitura(dados: Array) -> int:
	var counter: int
	
	for trilha in dados:
		if trilha.has("atividades"):
			for atv in trilha["atividades"]:
				if atv["tipo"] == "leitura":
					counter += 1
					
	return counter

func contar_atividades_concluidas_jogo(dados: Array) -> int:
	var total_concluidas: int = 0
	
	for trilha in dados:
		if trilha.has("atividades"):
			for atividade in trilha["atividades"]:
				if atividade.has("tentativas") and atividade["tipo"] == "pratica":
					for tentativa in atividade["tentativas"]:if tentativa.has("status") and tentativa["status"] == true:
							total_concluidas += 1
							break 
							
	return total_concluidas

func contar_atividades_concluidas_leitura(dados: Array) -> int:
	var total_concluidas: int = 0
	
	for trilha in dados:
		if trilha.has("atividades"):
			for atividade in trilha["atividades"]:
				if atividade.has("tentativas") and atividade["tipo"] == "leitura":
					for tentativa in atividade["tentativas"]:if tentativa.has("status") and tentativa["status"] == true:
							total_concluidas += 1
							break 
							
	return total_concluidas

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
