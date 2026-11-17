extends Node

const URL_JOGO := "http://localhost:8080/jogo"

var trilhas: Array = []
var conquistas: Array = []
var itens: Array = []
var carregado: bool = false
var ranking_xp:Array = []

# Exemplo: atividades_por_id[11] contém os dados da atividade 11.
var atividades_por_id: Dictionary = {}


# Recebe só o objeto "jogo", seja do login ou da rota GET /jogo.
func carregar_catalogo(jogo: Dictionary) -> bool:

	#print(jogo)
	var novas_trilhas = jogo.get("trilhas")
	var novas_conquistas = jogo.get("conquistas")
	var novos_itens = jogo.get("itens")

	if not (novas_trilhas is Array and novas_conquistas is Array and novos_itens is Array):
		return false
	print("CERTO 1")
	var indice: Dictionary = {}

	for trilha in novas_trilhas:
		if not (trilha is Dictionary) or not (trilha.get("atividades") is Array):
			print("TRILHA NAO É DICT OU NN POSSUI ATIVIDADES")
			return false

		for atividade in trilha["atividades"]:
			if not (atividade is Dictionary) or not atividade.has("atividadeId"):
				print("ATIVIDADE NÃO É DICT OU NN TEM ID")
				return false

			indice[int(atividade["atividadeId"])] = atividade
	print("CERTO 2")
	# Só substitui o catálogo depois de terminar a leitura.
	trilhas = novas_trilhas
	conquistas = novas_conquistas
	itens = novos_itens
	atividades_por_id = indice
	carregado = true
	return true


func buscar_atividade(atividade_id: int) -> Dictionary:
	return atividades_por_id.get(atividade_id, {})

func carregar_ranking() -> bool:
	var resposta: Dictionary = await Api.requisitar(
		HTTPClient.METHOD_GET,
		"/jogo/ranking"
	)

	if not resposta["ok"]:
		push_warning("Erro ao carregar ranking: " + str(resposta["mensagem"]))
		return false

	# O Api já converteu o JSON. A rota retorna uma lista de jogadores.
	var dados = resposta["dados"]

	if not (dados is Array):
		push_warning("O ranking retornou em um formato inválido.")
		return false

	# Uma lista vazia também é válida: significa que não há jogadores.
	ranking_xp = dados
	return true
# Use com "await". Faz uma requisição apenas quando for chamada.
# O HTTPRequest é criado aqui; não precisa adicionar um nó pelo editor.
func carregar_da_api() -> bool:
	if Sessao.access_token.is_empty():
		return false

	var http := HTTPRequest.new()
	add_child(http)
	http.timeout = 10.0

	var headers := PackedStringArray([
		"Accept: application/json",
		"Authorization: Bearer " + Sessao.access_token
	])

	var erro := http.request(URL_JOGO, headers, HTTPClient.METHOD_GET)
	if erro != OK:
		http.queue_free()
		return false

	var retorno = await http.request_completed
	http.queue_free()

	# A Godot devolve: [resultado, código HTTP, cabeçalhos, corpo].
	if retorno[0] != HTTPRequest.RESULT_SUCCESS or retorno[1] != 200:
		return false

	var corpo: PackedByteArray = retorno[3]
	var jogo = JSON.parse_string(corpo.get_string_from_utf8())
	if not (jogo is Dictionary):
		return false

	return carregar_catalogo(jogo)


# Guarda o ID da atividade de leitura selecionada.
# -1 significa que nenhuma foi encontrada.
var atividade_leitura_id: int = -1


func buscar_id_leitura(trilha_id: int) -> int:
	for trilha in trilhas:
		if int(trilha["trilhaId"]) != trilha_id:
			continue

		# A atividade número 0 é a leitura dessa trilha.
		for atividade in trilha["atividades"]:
			if int(atividade["numeroAtividade"]) == 0:
				return int(atividade["atividadeId"])

	# A trilha não existe ou não possui uma leitura.
	return -1
