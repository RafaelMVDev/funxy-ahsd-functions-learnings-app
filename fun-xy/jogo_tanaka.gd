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
"""Adicionado Morales : criei um node pra fazer http requests"""
@onready var http_salvamento: HTTPRequest = $SalvarProgressoHTTP

var quantidade_movimentos: int = 0
var funcao_armazenada: String   #Referente ao visor
var dominio_armazenado: String  #Referente ao visor
var linhas_desenhadas: Array[Line2D] = [] #Linhas válidas
var linha_desconexa: Array[Line2D] = [] 
var lista_funcoes: Array[String] = [] #Para enviar a API, de modo a reconstruir o histórico de funções
var lista_funcoes_validas: Array[String] = []
var lista_dominios: Array[String] = []

"""Adicionado (Morales): variaveis uteis para salvamento e funcionalidade de salvar uuid tentativa"""
var tentativa_uuid: String #Referente ao id da tentativa para salvamento no banco
var atividade_id: int = 1 # Dps ver como vai puxar isso
var rota_salvar : String = "%s/progresso/pratica/%d/salvar" % [Sessao.API_BASE_URL,atividade_id]

var salvando: bool = false
var fase_concluida: bool = false
var conclusao_confirmada: bool = false

"""Adicionado (Morales) - Função que gera um novo uuid para cada tentativa da atividade:"""
func _gerar_uuid_tentativa() -> String:
	# Um UUID tem 128 bits, ou seja, 16 bytes.
	var bytes := Crypto.new().generate_random_bytes(16)

	# No 7º byte (índice 6), coloca o número 4 nos quatro primeiros bits.
# Isso identifica a versão 4 do UUID e preserva os outros bits aleatórios.
	bytes[6] = (bytes[6] & 0x0f) | 0x40

	# No 9º byte (índice 8), define os dois primeiros bits como 1 e 0.
	# Essa combinação indica a variante padrão do UUID.
	bytes[8] = (bytes[8] & 0x3f) | 0x80

	# Cada byte vira dois caracteres hexadecimais, totalizando 32 caracteres.
	var hex := bytes.hex_encode()

	# substr(início, quantidade) recorta os grupos no formato 8-4-4-4-12.
	# Exemplo: 550e8400-e29b-41d4-a716-446655440000
	return "%s-%s-%s-%s-%s" % [
   		hex.substr(0, 8),
   		hex.substr(8, 4),
   		hex.substr(12, 4),
   		hex.substr(16, 4),
   		hex.substr(20, 12)
	]

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
	#PRECISA GERAR UM NOVO UUID DA PARTIDA AQUI E SALVAR EM ALGUM LUGAR!!!
	#Adicionado (morales)
	tentativa_uuid = _gerar_uuid_tentativa()
	
	
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
	#Verificar se há algum registro desse id com status "incompleto"
	#Se sim, dará update para status = "completo" e nos demais dados
	#Se não, vai criar um novo histórico
	#Marcar a data do final
	
	""" ==== Comentado(Morales) vvvvvvv: Novo formato de dicionario para api mais simplificado ==== """
	
	#var dic_para_api = {
			#"trilhaId": 1, #Obtido da API quando a fase carrega
			#"atividadeId": 5, #Obtido da API quando a fase carrega
			#"tentativa": {
			#"tentativaUuid":tentativa_uuid, #Alterado(Morales): identificador Unico da tentativa do player na mesma atividade
			#"concluida": true, #Alterado(Morales): True: fase concluida, False: em andamento
			#"progressoEspecifico": {
				#"listaFuncoes": lista_funcoes,
				#"listaFuncoesValidas": lista_funcoes_validas,
				#"listaDominios": lista_dominios,
				#"movimentos": quantidade_movimentos
			#}
		#}
	#}
	"""
	var dic_para_api = {
    # Gerado ao iniciar a tentativa ou recuperado da API ao continuar.
    	"tentativaUuid": tentativa_uuid,
    	"concluida": true, #true ao concluir, false ao salvar em andamento.
    	"listaFuncoes": lista_funcoes,
    	"listaFuncoesValidas": lista_funcoes_validas,
    	"listaDominios": lista_dominios,
    	"movimentos": quantidade_movimentos
	}
	print(dic_para_api)
	"""
	
	"""Adicionado Morales: função para montar requisição para api e tratar resultado"""
	var concluida = true
	salvar_progresso_atividade_api(concluida)

func sair_da_partida() -> void:
	#Enviar dados para a API
	get_tree().change_scene_to_file("res://homepage.tscn")
	#DADOS
	# quantidade_movimentos
	# lista_funcoes_validas
	# lista_dominios
	# lista_funcoes, para a exibição das funções anteriores
	# status = "incompleto"
	"""todo: ==== Comentado(Morales) vvvvvvv: Novo formato de dicionario para api mais simplificado ===="""
	#var dic_para_api = {
			#"trilhaId": 1,
			#"atividadeId": 5,
			#"tentativa": {
			#"concluida": false, #Alterado(Morales), True: pra bater com  com dic pra enviar
			#"tentaiva_uuid": tentativa_uuid,
			#"progressoEspecifico": {
				#"listaFuncoes": lista_funcoes,
				#"listaFuncoesValidas": lista_funcoes_validas,
				#"listaDominios": lista_dominios,
				#"movimentos": quantidade_movimentos
			#}
		#}
	#}
	var concluida = false
	salvar_progresso_atividade_api(concluida)
	#FORMATO DO DICIONARIO QUE TA SENDO ENVIADO AQUI EMBAIXO
	"""todo: ==== Adicionado(Morales) vvvvvvv: Novo formato de dicionario para api mais simplificado ===="""
	"""var dic_para_api = {
    # Gerado ao iniciar a tentativa ou recuperado da API ao continuar.
    	"tentativaUuid": tentativa_uuid,
    	"concluida": false, #true ao concluir, false ao salvar em andamento.
    	"listaFuncoes": lista_funcoes,
    	"listaFuncoesValidas": lista_funcoes_validas,
    	"listaDominios": lista_dominios,
    	"movimentos": quantidade_movimentos
	}"""
		
	
	
""" Adicionado morales: funcao que manda uma requisicao pra api salvar"""
func salvar_progresso_atividade_api(concluida: bool) -> bool:
	if salvando: #Evita enviar 2 requests antes do primeiro ser finalizado
		return false

	#Token vazio = usuário nn logou, sem atividade_id tbm nn da 
	if Sessao.access_token.is_empty() or atividade_id <= 0:
		push_warning("Faça login e selecione uma atividade antes de salvar.")
		return false

	# Ao continuar uma tentativa, esta variável já contém o UUID vindo da API.
	# Em uma tentativa nova, geramos o UUID uma vez e o reutilizamos nos reenvios.
	if tentativa_uuid.is_empty(): #Fazer uma logica pra preencher ela se for uma ativadade em andamento
		tentativa_uuid = _gerar_uuid_tentativa()

	var dados := {
		"tentativaUuid": tentativa_uuid,
		"status": concluida,
		"listaFuncoes": lista_funcoes,
		"listaFuncoesValidas": lista_funcoes_validas,
		"listaDominios": lista_dominios,
		"movimentos": quantidade_movimentos
	}

	# Inicia o POST com o token do jogador e o corpo em JSON.
	salvando = true
	http_salvamento.timeout = 15.0

	var erro := http_salvamento.request(
		rota_salvar,
		Sessao.cabecalhos_autenticados(), #Checar dados_globais/sessao.gd pra ver isso!
		HTTPClient.METHOD_POST,
		JSON.stringify(dados)
	)

	if erro != OK:
		salvando = false
		push_warning("Não foi possível iniciar o envio: " + error_string(erro))
		return false

	# O sinal retorna [resultado, código HTTP, cabeçalhos, corpo].
	var resposta: Array = await http_salvamento.request_completed
	salvando = false

	var resultado: int = resposta[0]
	var codigo_http: int = resposta[1]
	var corpo: PackedByteArray = resposta[3]

	if resultado != HTTPRequest.RESULT_SUCCESS:
		push_warning("Falha de conexão. Tente salvar novamente.")
		return false

	if codigo_http != 200:
		push_warning("Erro HTTP %d: %s" % [codigo_http, corpo.get_string_from_utf8()])
		return false

	var tentativa = JSON.parse_string(corpo.get_string_from_utf8())
	if not (tentativa is Dictionary) or not tentativa.has("progressoId"):
		push_warning("A API respondeu sem o progressoId da tentativa.")
		return false

	conclusao_confirmada = tentativa.get("atividadeConcluida", false)
	if concluida and not conclusao_confirmada:
		push_warning("A API recebeu o progresso, mas a fase ainda consta como aberta.")
		return false

	print("Progresso salvo! ID: ", tentativa["progressoId"])
	return true


func _process(_delta: float) -> void:
	pass
	
func _draw() -> void:
	draw_circle(Vector2(150,150), 5.0, Color.WHITE)
