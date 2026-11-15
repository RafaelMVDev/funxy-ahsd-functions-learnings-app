extends Button

@export var id_da_trilha: int
@export var id_do_botao: int
#@export var cena_do_jogo: String = "res://jogo_tanaka.tscn"

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	DadosGlobais.trilha_atual = id_da_trilha
	DadosGlobais.atv_atual = id_do_botao
	
	#Pegar da api e settar o xp da fase, para calcular a pontuação
	SceneTransition.change_scene("res://jogo_tanaka.tscn")
