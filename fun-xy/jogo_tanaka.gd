extends Control

@onready var menu_vitoria = $tela_vencedor
@onready var teclado_matematico = $TecladoMatematico
@onready var grafico = $FundoPlanoCartesiano/Grafico
@onready var painel_funcoes = $PainelFuncoes
@onready var botao_funcoes_antigas = $%BotaoFuncoesAntigas
@onready var visor_funcao = %VisorFuncao
@onready var virsor_dominio = %VisorDominio
@onready var botao_sair_partida = %BotaoSairPartida
@onready var botao_reiniciar_partida = %BotaoResetarPartida

var quantidade_movimentos: int = 0
var funcao_armazenada: String   #Referente ao visor
var dominio_armazenado: String  #Referente ao visor
var linhas_desenhadas: Array[Line2D] = [] #Linhas válidas
var linha_desconexa: Array[Line2D] = [] 
var lista_funcoes: Array[String] = [] #Para enviar a API, de modo a reconstruir o histórico de funções
var lista_funcoes_validas: Array[String] = []
var lista_dominios: Array[String] = []

func _ready() -> void:
	#O nó do aplicativo chama a função _iniciar_jogo
	#Passa como argumento o id da atividade que o player selecionou
	#Buscar na API os dados da atividade correspondente ao id
	
	#Dados constantes: obstáculos, inicio, fim, xp_base, intervalo de movimentos
	#Dados dependentes do status: número de movimentos, lista_funcoes
	
	#Se status != "incompleto", isto é, se for a primeira partida ou um reiniciar	
	
	teclado_matematico.formula_enviada.connect(_on_teclado_formula_enviada)
	teclado_matematico.dominio_enviado.connect(_on_teclado_dominio_enviado)
	teclado_matematico.voltar_movimento.connect(_voltar_movimento)
	grafico.vitoria.connect(_carregar_vitoria)
	botao_funcoes_antigas.pressed.connect(_on_exibir_funcoes_antigas)
	menu_vitoria.resetar_partida.connect(_reiniciar_partida)
	botao_reiniciar_partida.reiniciar_partida.connect(_reiniciar_partida)
	botao_sair_partida.sair_partida.connect(sair_da_partida)
	queue_redraw()
	
func _reiniciar_partida(): 
	get_tree().reload_current_scene()
	
func _on_exibir_funcoes_antigas():
	painel_funcoes.visible = not painel_funcoes.visible
		
func _on_teclado_formula_enviada(expressao: String):
	funcao_armazenada = expressao
	if dominio_armazenado:
		grafico.atualizar_grafico(funcao_armazenada, dominio_armazenado)
		_resetar()
	
func _on_teclado_dominio_enviado(dominio: String):
	if dominio.is_empty():
		dominio_armazenado = "-5<x<5"
	else:
		dominio_armazenado = dominio
	if funcao_armazenada:
		grafico.atualizar_grafico(funcao_armazenada, dominio_armazenado)
		_resetar()
	
func _voltar_movimento():
	if not linhas_desenhadas.is_empty():
		linhas_desenhadas.pop_back().queue_free()
		lista_dominios.pop_back()
		lista_funcoes_validas.pop_back()
		if not linhas_desenhadas.is_empty():
			linhas_desenhadas.back().default_color = Color.GREEN
		
func _resetar():
	funcao_armazenada = ""
	dominio_armazenado = ""

func _carregar_vitoria():
	menu_vitoria.exibir_tela_vitoria(quantidade_movimentos) #E pontuação
	#Varificar se há algum registro desse id com status "incompleto"
	#Se sim, dará update para status = "compelto" e nos demais dados
	#Se não, vai criar um novo histórico
	#Marcar a data do final
	var dic_para_api = {
			"trilhaId": 1, #Obtido da API quando a fase carrega
			"atividadeId": 5, #Obtido da API quando a fase carrega
			"tentativa": {
			"status": "completo",
			"progressoEspecifico": {
				"listaFuncoes": lista_funcoes,
				"listaFuncoesValidas": lista_funcoes_validas,
				"listaDominios": lista_dominios,
				"movimentos": quantidade_movimentos
			}
		}
	}
	print(dic_para_api)

func sair_da_partida() -> void:
	#Enviar dados para a API
	get_tree().change_scene_to_file("res://homepage.tscn")
	#DADOS
	# quantidade_movimentos
	# lista_funcoes_validas
	# lista_dominios
	# lista_funcoes, para a exibição das funções anteriores
	# status = "incompleto"
	
	var dic_para_api = {
			"trilhaId": 1,
			"atividadeId": 5,
			"tentativa": {
			"status": "em_andamento",
			"progressoEspecifico": {
				"listaFuncoes": lista_funcoes,
				"listaFuncoesValidas": lista_funcoes_validas,
				"listaDominios": lista_dominios,
				"movimentos": quantidade_movimentos
			}
		}
	}
		
	
func _process(_delta: float) -> void:
	pass
	
func _draw() -> void:
	draw_circle(Vector2(150,150), 5.0, Color.WHITE)
