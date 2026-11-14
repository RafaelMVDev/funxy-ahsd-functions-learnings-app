extends Node

const URL_JOGO := "http://localhost:8080/jogo"

var trilhas: Array = []
var conquistas: Array = []
var itens: Array = []
var carregado: bool = false

# Exemplo: atividades_por_id[11] contém os dados da atividade 11.
var atividades_por_id: Dictionary = {}


# Recebe só o objeto "jogo", seja do login ou da rota GET /jogo.
func carregar_catalogo(jogo: Dictionary) -> bool:
	var novas_trilhas = jogo.get("trilhas")
	var novas_conquistas = jogo.get("conquistas")
	var novos_itens = jogo.get("itens")

	if not (novas_trilhas is Array and novas_conquistas is Array and novos_itens is Array):
		return false

	var indice: Dictionary = {}

	for trilha in novas_trilhas:
		if not (trilha is Dictionary) or not (trilha.get("atividades") is Array):
			return false

		for atividade in trilha["atividades"]:
			if not (atividade is Dictionary) or not atividade.has("atividadeId"):
				return false

			indice[int(atividade["atividadeId"])] = atividade

	# Só substitui o catálogo depois de terminar a leitura.
	trilhas = novas_trilhas
	conquistas = novas_conquistas
	itens = novos_itens
	atividades_por_id = indice
	carregado = true
	return true


func buscar_atividade(atividade_id: int) -> Dictionary:
	return atividades_por_id.get(atividade_id, {})


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
