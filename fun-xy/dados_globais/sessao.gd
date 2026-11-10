extends Node

# Use o mesmo endereço que a tela de login usa para acessar a API.
const API_BASE_URL: String = "http://localhost:8080"

# Preenchido pela tela de login após autenticar o jogador.
var access_token: String = ""

# Preenchido pela tela de trilhas quando o jogador escolhe uma atividade.
# O valor 0 significa que nenhuma atividade foi selecionada.
var atividade_id: int = 0


func cabecalhos_autenticados() -> PackedStringArray:
	return PackedStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer " + access_token
	])


func encerrar_sessao() -> void:
	access_token = ""
	atividade_id = 0
