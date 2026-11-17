extends Node

# Use o mesmo endereço que a tela de login usa para acessar a API.

const URL_BASE: String = "http://localhost:8080"
# Preenchido pela tela de login após autenticar o jogador.

#Quando terminar o jogo, atualizar o banco de dados e a API reenvia os dados
"""
var access_token: String = "access-token-mock"
var refresh_token: String = "refresh-token-mock"

var player: Dictionary = {
	"id": 7,
	"nome": "Lia",
	"email": "lia@funxy.example",
	"sequencia": 3,
	"moedas": 41,
	"xp": 120
}

var player_configuracao: Dictionary = {
	"tema": "escuro",
	"idioma": "pt-BR",
	"notificacao": true
}

var player_inventario: Array = [
	{
		"inventarioId": 51,
		"itemId": 1,
		"descricao": "Avatar de raposa",
		"metadados": '{"imagem":"/imagens/itens/avatar-raposa.png"}',
		"tipo": "loja",
		"estilo": "avatar",
		"equipado": true
	}
]

var player_conquistas: Array = [
	{
		"conquistaId": 1,
		"desbloqueadaEm": "2026-11-10T14:10:00"
	}
]

var player_trilhas: Array = [
	{
		"trilhaId": 1,
		"atividades": [
			{
				# Leitura: duas tentativas concluídas, a mais recente primeiro.
				"atividadeId": 10,
				"tipo": "leitura",
				"tentativas": [
					{
						"progressoId": 43,
						"status": true,
						"concluidaEm": "2026-11-13T16:20:00",
						"progressoEspecifico": {
							"paginaAtual": 3
						}
					},
					{
						"progressoId": 41,
						"status": true,
						"concluidaEm": "2026-11-10T14:10:00",
						"progressoEspecifico": {
							"paginaAtual": 3
						}
					}
				]
			},
			{
				# Prática: uma tentativa em andamento.
				"atividadeId": 1,
				"tipo": "pratica",
				"tentativas": [
					{
						"progressoId": 42,
						"status": false,
						"concluidaEm": null,
						"progressoEspecifico": {
							"listaFuncoes": ["x", "2*x", "2"],
							"listaFuncoesValidas": ["x", "2"], #Não vai mais precisar
							"listaDominios": ["-5<x<2", "-5<x<2", "-5<x<5"],
							"movimentos": 3,
							"tentativaUuid": "aa44ae13-5f82-4391-a7b7-9a8853ea8f29"
						}
					}
				]
			}
		]
	}
]
"""
var access_token: String = "access-token-mock"
var refresh_token: String = "refresh-token-mock"
var versao_sessao: int = 0
var player: Dictionary = {
	
}

var player_configuracao: Dictionary = {
	
}

var player_inventario: Array = [
	
]

var player_conquistas: Array = [
	
]

var player_trilhas: Array = [
	
]
# Recebe a resposta INTEIRA do POST /auth/login.
# Retorna false se não vierem os dados necessários para entrar.
func carregar_do_login(resposta: Dictionary) -> bool:
	var dados = resposta.get("userDados")
	#print(dados)
	if not (dados is Dictionary):
		return false
	
	var perfil = dados.get("usuario")
	if not (perfil is Dictionary) or not perfil.has("id"):
		return false
	
	# No DTO o nome é "accessToken". O segundo nome cobre a grafia
	# "acessToken" que aparecia no seu script antigo.
	var access = resposta.get("accessToken","")
	var refresh = resposta.get("refreshToken", "")
	
	if not (access is String) or access.is_empty():
		return false
	if not (refresh is String) or refresh.is_empty():
		return false
	#print("ambos tokens sao string")
	var inventario = dados.get("inventario", [])
	var conquistas = dados.get("conquistas", [])
	var trilhas = dados.get("trilhas", [])
	#print(trilhas)
	if not (inventario is Array and conquistas is Array and trilhas is Array):
		return false

	access_token = access
	refresh_token = refresh
	player = perfil
	player_inventario = inventario
	player_conquistas = conquistas
	player_trilhas = trilhas

	# No primeiro login, o backend pode retornar "configuracao": null.
	var config = dados.get("configuracao")
	player_configuracao = config if config is Dictionary else {}
	print(player)
	return true

# Retorna as tentativas do jogador em uma fase.
# Se ele nunca abriu a fase, retorna [].
func buscar_tentativas(trilha_id: int, atividade_id: int) -> Array:
	for trilha in player_trilhas:
		if int(trilha["trilhaId"]) != trilha_id:
			continue

		for atividade in trilha["atividades"]:
			if int(atividade["atividadeId"]) == atividade_id and atividade["tipo"] == "pratica":
				return atividade["tentativas"]

	return []

func iniciar_sessao(access: String, refresh: String) -> void:
	versao_sessao += 1
	atualizar_tokens(access, refresh)


# Usado também após renovar os tokens.
func atualizar_tokens(access: String, refresh: String) -> void:
	access_token = access
	refresh_token = refresh

func encerrar_sessao() -> void:
	versao_sessao += 1
	access_token = ""
	refresh_token = ""     
	player = {}
	player_configuracao = {}
	player_inventario = []
	player_conquistas = []
	player_trilhas = []
	
func cabecalhos_autenticados() -> PackedStringArray:
	return PackedStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer " + access_token
	])


func atualizarProgresso() -> bool: #Mas não salva o status né
	# Busca o progresso atualizado do jogador autenticado.
	var resposta: Dictionary = await Api.requisitar(
		HTTPClient.METHOD_GET,
		"/api/usuario/me/progresso",
		"",
		true
	)

	# Em caso de erro, mantém os dados que já estavam na sessão.
	if not resposta.get("ok", false):
		push_warning(str(resposta.get("mensagem", "Erro ao atualizar o progresso.")))
		return false

	var trilhas = resposta.get("dados")

	# O endpoint deve retornar uma lista, inclusive [] se não houver progresso.
	if not (trilhas is Array):
		push_warning("A API não retornou uma lista de trilhas.")
		return false

	# Substitui os dados locais pelos dados atualizados do banco.
	player_trilhas = trilhas
	#print(player_trilhas)
	return true

func atualizar_recompensas(valor_xp: int, valor_moedas: int) -> bool:
	#Somar com o valor antigo
	var tudo_ok: bool = true
	var novo_xp
	var novo_moedas
	
	if not player["xp"]:
		novo_xp = valor_xp 
	else: 
		novo_xp = player["xp"] + valor_xp
	
	if not player["moedas"]:
		novo_moedas = valor_moedas
	else:
		novo_moedas = player["moedas"] + valor_moedas
	
	var corpo_xp = JSON.stringify({"xp": novo_xp})
	var resposta_xp: Dictionary = await Api.requisitar(
		HTTPClient.METHOD_PATCH,
		"/api/usuario/me/xp",
		corpo_xp,
		true
	)
	
	if resposta_xp.get("ok", false):
		var dados_perfil = resposta_xp.get("dados")
		if dados_perfil is Dictionary:
			player = dados_perfil
	else:
		push_warning(str(resposta_xp.get("mensagem", "Erro ao atualizar XP no banco.")))
		tudo_ok = false

	var corpo_moedas = JSON.stringify({"moedas": novo_moedas})
	var resposta_moedas: Dictionary = await Api.requisitar(
		HTTPClient.METHOD_PATCH,
		"/api/usuario/me/moedas",
		corpo_moedas,
		true
	)
	
	if resposta_moedas.get("ok", false):
		var dados_perfil = resposta_moedas.get("dados")
		if dados_perfil is Dictionary:
			player = dados_perfil
	else:
		push_warning(str(resposta_moedas.get("mensagem", "Erro ao atualizar moedas no banco.")))
		tudo_ok = false

	return tudo_ok
	
# Recebe o caminho escolhido pelo FileDialog e envia a foto para a API.
func enviar_foto(caminho: String) -> bool:
	var imagem := Image.new()

	if imagem.load(caminho) != OK:
		push_warning("Não foi possível abrir a imagem selecionada.")
		return false

	# Converte para PNG, mesmo que a imagem original seja JPEG.
	var bytes: PackedByteArray = imagem.save_png_to_buffer()

	if bytes.is_empty():
		push_warning("Não foi possível converter a imagem para PNG.")
		return false

	var http := HTTPRequest.new()
	add_child(http)
	http.timeout = 15.0

	var headers := PackedStringArray([
		"Content-Type: image/png",
		"Authorization: Bearer " + Sessao.access_token
	])

	# Envia os bytes da imagem diretamente, sem converter para JSON.
	var erro: int = http.request_raw(
		URL_BASE + "/api/usuario/me/foto",
		headers,
		HTTPClient.METHOD_PUT,
		bytes
	)

	if erro != OK:
		http.queue_free()
		push_warning("Não foi possível iniciar o envio da foto.")
		return false

	var resposta: Array = await http.request_completed
	http.queue_free()

	if resposta[0] != HTTPRequest.RESULT_SUCCESS:
		push_warning("Falha de conexão ao enviar a foto.")
		return false

	var codigo: int = resposta[1]

	# O backend retorna 204, sem corpo, quando salva corretamente.
	if codigo != 204:
		push_warning("Erro ao salvar a foto. HTTP %d." % codigo)
		return false

	return true
	
func buscar_foto() -> ImageTexture:
	var http := HTTPRequest.new()
	add_child(http)
	http.timeout = 15.0

	var headers := PackedStringArray([
		"Accept: image/png",
		"Authorization: Bearer " + Sessao.access_token
	])

	var erro: int = http.request(
		URL_BASE + "/api/usuario/me/foto",
		headers,
		HTTPClient.METHOD_GET
	)

	if erro != OK:
		http.queue_free()
		push_warning("Não foi possível iniciar a busca da foto.")
		return null

	var resposta: Array = await http.request_completed
	http.queue_free()

	if resposta[0] != HTTPRequest.RESULT_SUCCESS:
		push_warning("Falha de conexão ao buscar a foto.")
		return null

	var codigo: int = resposta[1]

	# O usuário ainda não possui uma foto.
	if codigo == 404:
		return null

	if codigo != 200:
		push_warning("Erro ao buscar a foto. HTTP %d." % codigo)
		return null

	# O corpo contém bytes de PNG, não JSON.
	var corpo: PackedByteArray = resposta[3]
	var imagem := Image.new()

	if imagem.load_png_from_buffer(corpo) != OK:
		push_warning("A resposta não contém uma imagem PNG válida.")
		return null

	return ImageTexture.create_from_image(imagem)
	
