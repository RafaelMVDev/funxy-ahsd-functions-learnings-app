extends Control

@onready var email_input = %LineEdit_EmailUsuario
@onready var senha_input = %LineEdit_Senha
@onready var label_mensagem = %Label_Mensagem
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var botao_senha: Button = %ButtonSenha
# Subsitua pela URL fornecida pelo seu colega (ou pelo Mocky)
var url_api = "http://localhost:8080/auth/login"
var icone_olho_aberto = preload("res://images/icones/olho.svg")
var icone_olho_fechado = preload("res://images/olho-fechado.svg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Conecta o sinal de resposta do HTTPRequest
	http_request.request_completed.connect(_on_login_response)

func _on_button_entrar_pressed():
	label_mensagem.visible = false
	var email = email_input.text
	var senha = senha_input.text
	
	if email.is_empty() or senha.is_empty():
		label_mensagem.text = "Preencha todos os campos!"
		label_mensagem.visible = true
		return
	
	if not verificar_email(email):
		label_mensagem.text = "Email inválido"
		label_mensagem.visible = true
		return
	
	label_mensagem.visible = true
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
	
	#Precisa das mensagens de erro! Usuário não encontrado ou senha incorreta

func _on_login_response(result, response_code, headers, body):
	# Converte o corpo da resposta de texto UTF-8 para JSON
	var json = JSON.new()
	var error = json.parse(body.get_string_from_utf8())

	if error == OK:
		var resposta = json.get_data()
		print(response_code)
		# Verifica o status retornado pela API provisória
		if response_code == 200:
			label_mensagem.text = "Sucesso! Redirecionando..."
			print("AcessToken recebido: ", resposta.get("acessToken"))
			print("RefreshToken recebido: ", resposta.get("refreshToken"))
			
			# Transição para o menu principal
			get_tree().change_scene_to_file("res://homepage.tscn")
		else:
			label_mensagem.text = resposta.get("mensagem", "Erro ao fazer login.")
	else:
		label_mensagem.text = "Erro ao processar resposta do servidor."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_cadastro_pressed() -> void:
	get_tree().change_scene_to_file("res://cadastro.tscn")

func _on_button_senha_pressed() -> void:
	if senha_input.secret == false:
		senha_input.secret = true
		botao_senha.icon = icone_olho_fechado
	else:
		senha_input.secret = false
		botao_senha.icon = icone_olho_aberto

func verificar_email(email: String) -> bool:
	var regex = RegEx.new()
	var padrao = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
	
	var erro = regex.compile(padrao)
	if erro != OK:
		return false
		
	var resultado = regex.search(email)
	
	if resultado and resultado.get_string() == email:
		return true
		
	return false
