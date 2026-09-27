extends Control

@onready var email_input = $PanelContainer/VBoxContainer/LineEdit_EmailUsuario
@onready var senha_input = $PanelContainer/VBoxContainer/LineEdit_Senha
@onready var label_mensagem = $PanelContainer/VBoxContainer/Label_Mensagem
@onready var http_request: HTTPRequest = $PanelContainer/VBoxContainer/HTTPRequest

# Subsitua pela URL fornecida pelo seu colega (ou pelo Mocky)
var url_api = "http://localhost:8080/api/login"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Conecta o sinal de resposta do HTTPRequest
	http_request.request_completed.connect(_on_login_response)

func _on_button_entrar_pressed():
	var email = email_input.text
	var senha = senha_input.text
	
	if email.is_empty() or senha.is_empty():
		label_mensagem.text = "Preencha todos os campos!"
		return
	
	label_mensagem.text = "Conectando..."
	
	# Monta o dicionário com os dados
	var dados = {
		"email": email,
		"senha": senha
	}
	
	# Converte o dicionário para uma String no formato JSON
	var json_body = JSON.stringify(dados)
	var headers = ["Content-Type: application/json"]
	
	# Envia a requisição POST para a API
	http_request.request(url_api, headers, HTTPClient.METHOD_POST, json_body)

func _on_login_response(result, response_code, headers, body):
	# Converte o corpo da resposta de texto UTF-8 para JSON
	var json = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	
	if error == OK:
		var resposta = json.get_data()
		
		# Verifica o status retornado pela API provisória
		if response_code == 200 and resposta.get("sucesso", false):
			label_mensagem.text = "Sucesso! Redirecionando..."
			print("Token recebido: ", resposta.get("token"))
			
			# Transição para o menu principal
			get_tree().change_scene_to_file("res://homepage.tscn")
		else:
			label_mensagem.text = resposta.get("mensagem", "Erro ao fazer login.")
	else:
		label_mensagem.text = "Erro ao processar resposta do servidor."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
