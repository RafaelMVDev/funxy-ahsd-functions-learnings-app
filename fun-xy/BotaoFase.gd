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
				break # Achou false (prioridade máxima), pode parar o loop imediatamente
			elif tentativa["status"] == true:
				tem_concluida = true
	
	# Aplicação dos estilos baseada nas flags
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
	var estilo_botao = StyleBoxFlat.new()
	estilo_botao.set_border_width_all(4)
	estilo_botao.set_corner_radius_all(45)
	estilo_botao.border_color = Color(1.0, 1.0, 1.0, 1.0) 
	estilo_botao.bg_color = Color("df6316ff") 
	add_theme_stylebox_override("normal", estilo_botao)
	
func aplicar_estilo_concluido() -> void:
	var estilo_botao = StyleBoxFlat.new()
	estilo_botao.set_border_width_all(4)
	estilo_botao.set_corner_radius_all(45)
	estilo_botao.border_color = Color(1.0, 1.0, 1.0, 1.0) 
	estilo_botao.bg_color = Color("418af9") 
	add_theme_stylebox_override("normal", estilo_botao)
	text = "✔"

func aplicar_estilo_bloqueado() -> void:
	var estilo_botao = StyleBoxFlat.new()
	estilo_botao.set_border_width_all(4)
	estilo_botao.set_corner_radius_all(45)
	estilo_botao.border_color = Color(0.018, 0.0, 0.222, 1.0) 
	estilo_botao.bg_color = Color("16305bff") 
	add_theme_stylebox_override("disabled", estilo_botao)
