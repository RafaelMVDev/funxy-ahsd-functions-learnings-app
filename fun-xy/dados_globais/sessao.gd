extends Node

# Use o mesmo endereço que a tela de login usa para acessar a API.
const API_BASE_URL: String = "http://localhost:8080"

# Preenchido pela tela de login após autenticar o jogador.

#Quando terminar o jogo, atualizar o banco de dados e a API reenvia os dados

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


# Recebe a resposta INTEIRA do POST /auth/login.
# Retorna false se não vierem os dados necessários para entrar.
func carregar_do_login(resposta: Dictionary) -> bool:
	var dados = resposta.get("userDados")
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
			if int(atividade["atividadeId"]) == atividade_id and atividade["tipo"] == "pratica":
				return atividade["tentativas"]

	return []

func atualizar_status(trilha_id: int, atividade_id: int, id_tentativa: int):
	for trilha in player_trilhas:
		if trilha["trilhaId"] == trilha_id:
			for atividade in trilha["atividades"]:
				if atividade["atividadeId"] == atividade_id:
					for tentativa in atividade["tentativas"]:
						if tentativa["progressoId"] == id_tentativa:
							print("ALTERANDO STATUS")
							tentativa["status"] = true
	
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
