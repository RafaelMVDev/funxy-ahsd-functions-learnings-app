extends Button

@export var id_da_trilha: int
@export var id_do_botao: int

const PRIMEIRAS_ATIVIDADES = [1.0, 4.0, 7.0, 10.0, 13.0]

func _ready():
	pressed.connect(_on_pressed)
	atualizar_estilo_do_botao(Sessao.buscar_tentativas(id_da_trilha, id_do_botao))
	verificar_disponibilidade(id_da_trilha, id_do_botao)

func _on_pressed():
	DadosGlobais.trilha_atual = id_da_trilha
	DadosGlobais.atv_atual = id_do_botao
	
	#Pegar da api e settar o xp da fase, para calcular a pontuação
	SceneTransition.change_scene("res://jogo_tanaka.tscn")

func atualizar_estilo_do_botao(tentativas: Array) -> void:
	var tem_concluida: bool = false
	var tem_incompleta: bool = false
	
	for tentativa in tentativas:
		if tentativa.has("status"):
			if tentativa["status"] == false:
				tem_incompleta = true
				break 
			elif tentativa["status"] == true:
				tem_concluida = true
	
	if tem_incompleta:
		aplicar_estilo_incompleto()
	elif tem_concluida:
		aplicar_estilo_concluido()

func verificar_disponibilidade(trilha: float, id_atv: float) -> void:
	if id_atv in PRIMEIRAS_ATIVIDADES:
		disabled = false
		return 
	var tentativas_anterior = Sessao.buscar_tentativas(trilha, id_atv - 1.0)
	var anterior_concluida: bool = false
	
	for tentativa in tentativas_anterior:
		if tentativa.has("status") and tentativa["status"] == true:
			anterior_concluida = true
			break 
	
	if not anterior_concluida:
		disabled = true
		aplicar_estilo_bloqueado()
	else:
		disabled = false

func aplicar_estilo_incompleto() -> void:
	tooltip_text = "Em andamento"
	var estilo_botao = StyleBoxFlat.new()
	estilo_botao.set_border_width_all(4)
	estilo_botao.set_corner_radius_all(45)
	estilo_botao.border_color = Color("95551cff") 
	estilo_botao.bg_color = Color("e4551cff") 
	add_theme_stylebox_override("normal", estilo_botao)
	
	var estilo_hover = estilo_botao.duplicate()
	estilo_hover.set_border_width_all(6)
	add_theme_stylebox_override("hover", estilo_hover)
	
func aplicar_estilo_concluido() -> void:
	tooltip_text = "Concluída"
	var estilo_botao = StyleBoxFlat.new()
	estilo_botao.set_border_width_all(4)
	estilo_botao.set_corner_radius_all(45)
	estilo_botao.border_color = Color("074336ff") 
	estilo_botao.bg_color = Color("16836c") 
	add_theme_stylebox_override("normal", estilo_botao)
	
	var estilo_hover = estilo_botao.duplicate()
	estilo_hover.set_border_width_all(6)
	add_theme_stylebox_override("hover", estilo_hover)
	
	text = "✔"
	
func aplicar_estilo_bloqueado() -> void:
	tooltip_text = "Bloqueada"
	var estilo_botao = StyleBoxFlat.new()
	estilo_botao.set_border_width_all(4)
	estilo_botao.set_corner_radius_all(45)
	estilo_botao.border_color = Color(0.018, 0.0, 0.222, 1.0) 
	estilo_botao.bg_color = Color("26354aff") 
	add_theme_stylebox_override("disabled", estilo_botao)
