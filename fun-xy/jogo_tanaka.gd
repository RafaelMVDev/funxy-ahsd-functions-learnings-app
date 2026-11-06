extends Control

@onready var menu_vitoria = $tela_vencedor
@onready var teclado_matematico = $TecladoMatematico
@onready var grafico = $FundoPlanoCartesiano/Grafico
@onready var painel_funcoes = $PainelFuncoes
@onready var botao_funcoes_antigas = $TecladoMatematico/VisoresTeclado/MarginContainer/HBoxContainer/BotaoFuncoesAntigas
@onready var visor_funcao = %VisorFuncao
@onready var virsor_dominio = %VisorDominio

var quantidade_movimentos: int = 0
var funcao_armazenada: String   #Referente ao visor
var dominio_armazenado: String  #Referente ao visor
var linhas_desenhadas: Array[Line2D] = [] #Linhas válidas
var linha_desconexa: Array[Line2D] = [] 
var lista_funcoes: Array[String] = [] #Para enviar ah API, de modo a reconstruir o históricod e funções

func _ready() -> void:
	teclado_matematico.formula_enviada.connect(_on_teclado_formula_enviada)
	teclado_matematico.dominio_enviado.connect(_on_teclado_dominio_enviado)
	teclado_matematico.voltar_movimento.connect(_voltar_movimento)
	grafico.vitoria.connect(_carregar_vitoria)
	botao_funcoes_antigas.pressed.connect(_on_exibir_funcoes_antigas)
	menu_vitoria.resetar_partida.connect(_iniciar_partida)
	queue_redraw()
	
func _iniciar_partida(): 
	#O nó do aplicativo chama a função _iniciar_jogo
	#Passa como argumento o id da atividade que o player selecionou
	#Buscar na API os dados da atividade correspondente ao id
	
	#Dados constantes: obstáculos, inicio, fim, xp_base, intervalo de movimentos
	#Dados dependentes do status: número de movimentos, lista_funcoes
	
	#Se status != "incompleto", isto é, se for a primeira partida ou um reiniciar	
	quantidade_movimentos = 0
	funcao_armazenada = ""
	dominio_armazenado = ""
	linhas_desenhadas = []
	linha_desconexa = []
	lista_funcoes = []
	visor_funcao.text = ""
	virsor_dominio.text = ""
	
	#Limpar os line2d
	get_tree().call_group("linhas", "queue_free")
	#limpar os filhos do painel das funções
	get_tree().call_group("painel_funcoes", "queue_free")
	#marcar data do início 
	menu_vitoria.visible = false
	

func _on_exibir_funcoes_antigas():
	painel_funcoes.visible = not painel_funcoes.visible
		
func _on_teclado_formula_enviada(expressao: String):
	print("Pai recebeu a fórmula: ", expressao)
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
		if not linhas_desenhadas.is_empty():
			linhas_desenhadas.back().default_color = Color.GREEN
		
func _resetar():
	funcao_armazenada = ""
	dominio_armazenado = ""

func _carregar_vitoria():
	menu_vitoria.exibir_tela_vitoria(quantidade_movimentos) #E pontuação
	#Enviar dados para a API: status: "completo", demais dados
	#Marcar a data do final
		
func _process(delta: float) -> void:
	pass
	
func _draw() -> void:
	draw_circle(Vector2(150,150), 5.0, Color.WHITE)
