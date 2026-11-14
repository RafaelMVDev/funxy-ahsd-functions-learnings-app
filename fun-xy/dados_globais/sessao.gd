extends Node

# Use o mesmo endereço que a tela de login usa para acessar a API.
const API_BASE_URL: String = "http://localhost:8080"

# Preenchido pela tela de login após autenticar o jogador.

var access_token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJmdW54eS1sZWFybmluZy1hcHAiLCJzdWIiOiIxIiwidG9rZW5fdHlwZSI6ImFjY2VzcyIsImlhdCI6MTc5NDMzMzc3MiwiZXhwIjoxNzk0MzQwOTcyfQ.7OsWRHPD3vRueeuvNSXY4ImOzm7W9V0Sq5NYKxO3fsw"
var refresh_token: String = ""

var player: Dictionary = {}
var player_configuracao: Dictionary = {}
var player_inventario: Array = []
var player_conquistas: Array = []
var player_trilhas: Array = []


# Recebe a resposta INTEIRA do POST /auth/login.
# Retorna false se não vierem os dados necessários para entrar.
func carregar_do_login(resposta: Dictionary) -> bool:
	var dados = resposta.get("dados")
	if not (dados is Dictionary):
		return false

	var perfil = dados.get("usuario")
	if not (perfil is Dictionary) or not perfil.has("id"):
		return false

	# No DTO o nome é "accessToken". O segundo nome cobre a grafia
	# "acessToken" que aparecia no seu script antigo.
	var access = resposta.get("accessToken", resposta.get("acessToken", ""))
	var refresh = resposta.get("refreshToken", "")

	if not (access is String) or access.is_empty():
		return false
	if not (refresh is String) or refresh.is_empty():
		return false

	var inventario = dados.get("inventario", [])
	var conquistas = dados.get("conquistas", [])
	var trilhas = dados.get("trilhas", [])
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

	return true


# Retorna as tentativas do jogador em uma fase.
# Se ele nunca abriu a fase, retorna [].
func buscar_tentativas(trilha_id: int, atividade_id: int) -> Array:
	for trilha in player_trilhas:
		if int(trilha["trilhaId"]) != trilha_id:
			continue

		for atividade in trilha["atividades"]:
			if int(atividade["atividadeId"]) == atividade_id:
				return atividade["tentativas"]

	return []


# Chame ao sair da conta para não manter os dados do jogador anterior.
func limpar() -> void:
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
