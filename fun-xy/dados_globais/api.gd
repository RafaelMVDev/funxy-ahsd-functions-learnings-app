extends Node

# Endereço do backend durante o desenvolvimento no mesmo computador.
const URL_BASE: String = "http://localhost:8080"

# Uma requisição pode aguardar o refresh iniciado por outra.
signal refresh_finalizado(resultado: Dictionary)

# A interface pode ouvir este sinal para voltar à tela de login.
signal sessao_expirada

var _renovando: bool = false

# Muda ao entrar ou sair da conta. Evita usar uma resposta antiga
# depois que o jogador já trocou de sessão.
var _versao_sessao: int = 0


# =========================================================
# MÉTODOS QUE AS TELAS USAM
# =========================================================

func buscar(rota: String) -> Dictionary:
	return await _autenticada(HTTPClient.METHOD_GET, rota)


func post(rota: String, dados: Dictionary) -> Dictionary:
	return await _autenticada(HTTPClient.METHOD_POST, rota, dados)


func put(rota: String, dados: Dictionary) -> Dictionary:
	return await _autenticada(HTTPClient.METHOD_PUT, rota, dados)


func patch(rota: String, dados: Dictionary) -> Dictionary:
	return await _autenticada(HTTPClient.METHOD_PATCH, rota, dados)


# =========================================================
# REQUISIÇÕES QUE PRECISAM DE ACCESS TOKEN
# =========================================================

func _autenticada(metodo: int, rota: String, dados = null) -> Dictionary:
	var versao: int = _versao_sessao
	var token_enviado: String = Sessao.access_token

	if token_enviado.is_empty():
		return _resultado(401, null, "Faça login para continuar.")

	# Guarda o corpo original. Se o access token expirar, repetimos
	# a requisição com os mesmos dados, inclusive o mesmo tentativaUuid.
	var corpo: String = ""
	if dados != null:
		corpo = JSON.stringify(dados)

	var resposta: Dictionary = await _enviar(metodo, rota, corpo, token_enviado)

	if versao != _versao_sessao:
		return _resultado(0, null, "A sessão mudou.")

	# Sucesso, erro de validação, conflito ou falha de rede:
	# devolve o resultado para a tela. Só o 401 tenta renovar.
	if resposta["codigo"] != 401:
		return resposta

	# Se outra requisição já renovou o token enquanto esperávamos,
	# podemos usar o token novo sem chamar /auth/refresh novamente.
	if token_enviado == Sessao.access_token:
		var renovacao: Dictionary = await _renovar_tokens()
		if not renovacao["ok"]:
			return renovacao

	if versao != _versao_sessao:
		return _resultado(0, null, "A sessão mudou.")

	# Repete uma única vez. Usar _enviar aqui evita um loop de refresh.
	var repeticao: Dictionary = await _enviar(
		metodo, rota, corpo, Sessao.access_token
	)

	if versao != _versao_sessao:
		return _resultado(0, null, "A sessão mudou.")

	return repeticao


# =========================================================
# REFRESH DOS TOKENS
# =========================================================



func _tem_par_de_tokens(dados) -> bool:
	if not (dados is Dictionary):
		return false

	var access = dados.get("accessToken")
	var refresh = dados.get("refreshToken")

	return (
		access is String and not access.is_empty()
		and refresh is String and not refresh.is_empty()
	)


# =========================================================
# ENVIO HTTP
# =========================================================

signal renovacao_finalizada(resultado: Dictionary)

const ROTA_REFRESH: String = "/auth/atualizarTokens"

var renovando_tokens: bool = false


# Função chamada pelas telas.
# autenticada = false: envia sem token e sem renovação automática.
# autenticada = true: envia o token e tenta renovar caso receba 401.
func requisitar(
		metodo: int,
		rota: String,
		corpo: String = "",
		autenticada: bool = true
) -> Dictionary:
	if not autenticada:
		return await _enviar(metodo, rota, corpo)

	var versao_original: int = Sessao.versao_sessao
	var token_enviado: String = Sessao.access_token

	var resposta: Dictionary = await _enviar(
		metodo, rota, corpo, token_enviado
	)

	if Sessao.versao_sessao != versao_original:
		return _resultado(0, null, "A sessão mudou durante a requisição.")

	if resposta["codigo"] != 401:
		return resposta

	# Se outra requisição já renovou o token, usamos o valor novo.
	# Se a renovação ainda estiver acontecendo, aguardamos.
	if renovando_tokens or Sessao.access_token == token_enviado:
		var renovacao: Dictionary = await _renovar_tokens()

		if Sessao.versao_sessao != versao_original:
			return _resultado(401, null, "A sessão foi encerrada ou alterada.")

		if not renovacao["ok"]:
			return renovacao

	if Sessao.access_token.is_empty():
		return _resultado(401, null, "Faça login para continuar.")

	# Repete UMA vez, com o mesmo corpo e o novo token.
	# Chamar _enviar diretamente impede um ciclo de renovações.
	var repeticao: Dictionary = await _enviar(
		metodo, rota, corpo, Sessao.access_token
	)

	if Sessao.versao_sessao != versao_original:
		return _resultado(0, null, "A sessão mudou durante a requisição.")

	return repeticao


func _renovar_tokens() -> Dictionary:
	# Compartilha o resultado da renovação em andamento.
	if renovando_tokens:
		var resultado_compartilhado: Dictionary = await renovacao_finalizada
		return resultado_compartilhado

	if Sessao.refresh_token.is_empty():
		return _resultado(401, null, "Faça login para continuar.")

	renovando_tokens = true

	var versao_original: int = Sessao.versao_sessao
	var corpo: String = JSON.stringify({
		"refreshToken": Sessao.refresh_token
	})

	# Sem Authorization. O refresh token vai no corpo.
	var resposta: Dictionary = await _enviar(
		HTTPClient.METHOD_POST,
		ROTA_REFRESH,
		corpo
	)

	if Sessao.versao_sessao != versao_original:
		resposta = _resultado(0, null, "A sessão mudou durante a renovação.")

	elif resposta["ok"]:
		var dados = resposta["dados"]

		if not (dados is Dictionary):
			resposta = _resultado(0, null, "Resposta de renovação inválida.")
		else:
			var novo_access = dados.get("accessToken")
			var novo_refresh = dados.get("refreshToken")

			if not (novo_access is String) or not (novo_refresh is String):
				resposta = _resultado(0, null, "A API não retornou os tokens esperados.")

			elif novo_access.is_empty() or novo_refresh.is_empty():
				resposta = _resultado(0, null, "A API retornou tokens vazios.")

			else:
				# Atualiza os dois, pois o refresh também pode ser substituído.
				Sessao.atualizar_tokens(novo_access, novo_refresh)

	elif resposta["codigo"] == 401:
		# Consideramos que o endpoint usa 401 para refresh inválido/expirado.
		Sessao.encerrar_sessao()
		resposta = _resultado(401, null, "Sua sessão expirou. Faça login novamente.")

	# Falha de conexão ou erro do servidor preservam os tokens.
	renovando_tokens = false
	renovacao_finalizada.emit(resposta)
	return resposta


# Executa apenas uma chamada HTTP.
# O token vazio significa que Authorization será omitido.
func _enviar(
		metodo: int,
		rota: String,
		corpo: String = "",
		token: String = ""
) -> Dictionary:
	var http: HTTPRequest = HTTPRequest.new()
	add_child(http)
	http.timeout = 10.0
	http.max_redirects = 0

	var headers: PackedStringArray = PackedStringArray([
		"Accept: application/json"
	])

	if not corpo.is_empty():
		headers.append("Content-Type: application/json")

	if not token.is_empty():
		headers.append("Authorization: Bearer " + token)

	var url: String = Sessao.API_BASE_URL.trim_suffix("/") + rota
	var erro: int = http.request(url, headers, metodo, corpo)

	if erro != OK:
		http.queue_free()
		return _resultado(0, null, "Não foi possível iniciar a conexão.")

	var retorno: Array = await http.request_completed
	http.queue_free()

	if retorno[0] != HTTPRequest.RESULT_SUCCESS:
		return _resultado(0, null, "Não foi possível confirmar a resposta do servidor.")

	var codigo: int = retorno[1]
	var bytes: PackedByteArray = retorno[3]
	var dados = null

	if not bytes.is_empty():
		dados = JSON.parse_string(bytes.get_string_from_utf8())

	var mensagem: String = ""

	if codigo < 200 or codigo >= 300:
		mensagem = "Erro HTTP %d." % codigo

		if dados is Dictionary:
			var erros = dados.get("erros")

			if erros is Array and not erros.is_empty():
				mensagem = str(erros[0])
			elif dados.get("mensagem") is String:
				mensagem = dados["mensagem"]
	print(dados)
	return _resultado(codigo, dados, mensagem)


func _resultado(
		codigo: int,
		dados = null,
		mensagem: String = ""
) -> Dictionary:
	return {
		"ok": codigo >= 200 and codigo < 300,
		"codigo": codigo,
		"dados": dados,
		"mensagem": mensagem
	}


# =========================================================
# LOGIN, LOGOUT E RESTAURAÇÃO
# =========================================================

# A tela de login chama isto DEPOIS de preencher Sessao e DadosJogo.
# Quem coloca os dados do jogador em Sessao é Sessao.carregar_do_login().
func registrar_login() -> void:
	_versao_sessao += 1
	_guardar_refresh()


# Limpa a sessão local. Não chama uma rota de logout no backend.
func sair() -> void:
	_versao_sessao += 1
	Sessao.limpar()

	var cofre: Node = get_node_or_null("/root/CofreTokens")
	if cofre != null:
		cofre.call("Apagar")


func _guardar_refresh() -> void:
	# Sem cofre, o refresh continua funcionando enquanto o jogo estiver aberto.
	var cofre: Node = get_node_or_null("/root/CofreTokens")
	if cofre == null:
		return

	var salvou: bool = cofre.call("Salvar", Sessao.refresh_token)
	if not salvou:
		push_warning("Sessão ativa, mas não foi possível lembrar o login.")


# Chamada pelo _ready() da tela de login.
func restaurar_sessao() -> Dictionary:
	var versao: int = _versao_sessao
	print("Tentando restaurar sessão")
	if Sessao.access_token.is_empty():
		# Ao abrir o jogo do zero, tenta recuperar o refresh salvo.
		if Sessao.refresh_token.is_empty():
			var cofre: Node = get_node_or_null("/root/CofreTokens")
			if cofre == null:
				return _resultado(401, null, "Nenhum login salvo.")

			var salvo: String = cofre.call("Ler")
			if salvo.is_empty():
				return _resultado(401, null, "Nenhum login salvo.")

			Sessao.refresh_token = salvo

		var renovacao: Dictionary = await _renovar_tokens()
		if not renovacao["ok"]:
			return renovacao

	# O refresh devolve tokens, não o perfil nem o catálogo.
	var usuario: Dictionary = await buscar("/api/usuario/me")
	if not usuario["ok"]:
		return usuario

	var jogo: Dictionary = await buscar("/jogo")
	if not jogo["ok"]:
		return jogo

	if versao != _versao_sessao:
		return _resultado(0, null, "A sessão mudou.")

	if not (jogo["dados"] is Dictionary):
		return _resultado(0, null, "Catálogo em formato inválido.")

	if not DadosJogo.carregar_catalogo(jogo["dados"]):
		return _resultado(0, null, "Não foi possível carregar as fases.")

	# Reaproveita a função do login em vez de montar o perfil duas vezes.
	var resposta_login: Dictionary = {
	"acessToken": Sessao.access_token,
	"refreshToken": Sessao.refresh_token,
	"userDados": usuario["dados"]
	}

	if not Sessao.carregar_do_login(resposta_login):
		return _resultado(0, null, "Dados do jogador em formato inválido.")

	return _resultado(200)
