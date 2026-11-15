extends Button

# @export permite que você altere esses valores no Inspector para cada botão
@export var id_da_trilha: int = 0
@export var id_do_botao: int = 0
@export var cena_do_jogo: String = "res://jogo_tanaka.tscn"

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	DadosGlobais.trilha_atual = id_da_trilha
	DadosGlobais.id_atual = id_do_botao
	
	#Pegar da api e settar o xp da fase, para calcular a pontuação
	get_tree().change_scene_to_file(cena_do_jogo)
