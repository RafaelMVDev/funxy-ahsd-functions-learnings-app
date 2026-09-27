extends Control

@onready var nome_input = $PanelContainer/VBoxContainer/LineEdit_Usuario
@onready var email_input = $PanelContainer/VBoxContainer/LineEdit_Email
@onready var senha_input = $PanelContainer/VBoxContainer/LineEdit_Senha
@onready var label_mensagem = $PanelContainer/VBoxContainer/Label_Mensagem
@onready var http_request: HTTPRequest = $PanelContainer/VBoxContainer/HTTPRequest

# Aponta para a nova rota da sua API Spring Boot
var url_api = "http://localhost:8080/api/cadastro"

func _ready():
	# Lembre-se: conectamos o sinal do HTTPRequest para ouvir a resposta do Java
	http_request.request_completed.connect(_on_cadastro_response)

func _on_button_pressed():
	var nome = nome_input.text.strip_edges()
	var email = email_input.text.strip_edges()
	var senha = senha_input.text.strip_edges()
	
	# Validação local no Godot (evita gastar a rede se faltar algo)
	if nome.is_empty() or email.is_empty() or senha.is_empty():
		label_mensagem.text = "Por favor, preencha todos os campos!"
		return
		
	if senha.length() < 6:
		label_mensagem.text = "A senha deve ter no mínimo 6 caracteres!"
		return

	label_mensagem.text = "Enviando cadastro..."
	
	# Monta o Dicionário com as chaves exatas que o Java espera (nome, email, senha)
	var dados = {
		"nome": nome,
		"email": email,
		"senha": senha
	}
	
	# Transforma o dicionário em texto no formato JSON
	var json_body = JSON.stringify(dados)
	var headers = ["Content-Type: application/json"]
	
	# Dispara a requisição HTTP tipo POST
	http_request.request(url_api, headers, HTTPClient.METHOD_POST, json_body)

func _on_cadastro_response(result, response_code, headers, body):
	var json = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	
	if error == OK:
		var resposta = json.get_data()
		
		# O Spring retorna 201 para recurso criado com sucesso
		if response_code == 201 and resposta.get("sucesso", false):
			label_mensagem.text = "Conta criada com sucesso!"
			
			# Aguarda 1.5 segundos para o usuário ler a mensagem e troca para o Login
			await get_tree().create_timer(1.5).timeout
			get_tree().change_scene_to_file("res://verificar_email.tscn")
		else:
			# Exibe a mensagem enviada pelo servidor (ex: "E-mail já cadastrado")
			label_mensagem.text = resposta.get("mensagem", "Erro ao cadastrar.")
	else:
		label_mensagem.text = "Falha de comunicação com o servidor."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
