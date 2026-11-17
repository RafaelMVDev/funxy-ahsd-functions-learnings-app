extends Control

#colocar @onready para pegar o panel de cada atv de leitura

var trilha_atv: int
var ultima_tela: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trilha_atv = DadosGlobais.trilha_leitura_atual
	ultima_tela = DadosGlobais.ultima_cena
	#carregar_material()
	
#func carregar_material() -> void:
	#if trilha_atv == 1: leituraTrilha1.visible = true

func sair_atv() -> void:
	SceneTransition.change_scene(ultima_tela)
	#Lógica de salvar o progresso da atv.
	#Como só vai ter um material de leitura por trilha, então pode enviar só a trilha:
	#trilha_atv
	salvar_atv_leitura()
	

func _process(delta: float) -> void:
	pass


func _on_button_sair_pressed() -> void:
	sair_atv()
	pass # Replace with function body.


func salvar_atv_leitura() -> void:
	var id_atv = DadosJogo.buscar_id_leitura(DadosGlobais.trilha_leitura_atual)
	Sessao.concluir_leitura(id_atv, 2)
	

func _on_button_voltar_pressed() -> void:
	if DadosGlobais.trilha_leitura_atual != 1:
		salvar_atv_leitura()
		DadosGlobais.trilha_leitura_atual -= 1
		get_tree().reload_current_scene()
		
func _on_button_avancar_pressed() -> void:
	if DadosGlobais.trilha_leitura_atual != 5:
		salvar_atv_leitura()
		DadosGlobais.trilha_leitura_atual += 1
		get_tree().reload_current_scene()
