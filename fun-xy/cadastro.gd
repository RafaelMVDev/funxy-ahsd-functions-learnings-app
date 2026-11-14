extends Control

@onready var login_panel = $SlideWindow/LoginPanel
@onready var register_panel = $SlideWindow/RegisterPanel

@onready var nome_input = %LineEdit_Usuario
@onready var email_input = %LineEdit_Email
@onready var senha_input = %LineEdit_Senha
@onready var label_mensagem = %Label_Mensagem
@onready var http_request: HTTPRequest = %HTTPRequest
@onready var botao_senha: Button = %ButtonSenha

@onready var email_input_login: LineEdit = %LineEdit_Email_Login
@onready var senha_input_login: LineEdit = %LineEdit_Senha_Login
@onready var label_mensagem_login: Label = %Label_Mensagem_Login
@onready var http_request_login: HTTPRequest = $HTTPRequest_Login
@onready var botao_senha_login: Button = %ButtonSenha_Login


# Aponta para a nova rota da sua API Spring Boot
const URL_LOGIN := "http://localhost:8080/auth/login"
var url_api = "http://localhost:8080/auth/registro"
var icone_olho_aberto = preload("res://images/icones/olho.svg")
var icone_olho_fechado = preload("res://images/olho-fechado.svg")
var entrando := false
var window_width: float = 250.0 
var slide_duration: float = 0.4

func _ready():
	http_request.timeout = 10.0

	if not http_request.request_completed.is_connected(_on_login_response):
		http_request.request_completed.connect(_on_login_response)
	# A tela acabou de abrir. Ainda não precisamos de nenhum token.
	entrando = false
	label_mensagem.visible = false
	# Lembre-se: conectamos o sinal do HTTPRequest para ouvir a resposta do Java
	http_request.request_completed.connect(_on_cadastro_response)
	label_mensagem.visible = false
	

# Conecte o botão "Não tem conta? Cadastre-se" (no LoginPanel) a esta função
func _on_btn_go_to_register_pressed():
	# create_tween() cria a animação. set_parallel(true) move os dois ao mesmo tempo.
	var tween = create_tween().set_parallel(true)
	# Deixa o movimento mais suave (acelera e desacelera)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	# O Login vai para a esquerda (negativo), o Cadastro vem para o centro (zero)
	tween.tween_property(login_panel, "position:x", -window_width-100, slide_duration)
	tween.tween_property(register_panel, "position:x", 0, slide_duration)

# Conecte o botão "Já tenho conta? Entrar" (no RegisterPanel) a esta função
func _on_btn_go_to_login_pressed():
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	# O Login volta para o centro (zero), o Cadastro volta para a direita (positivo)
	tween.tween_property(login_panel, "position:x", 0, slide_duration)
	tween.tween_property(register_panel, "position:x", window_width+100, slide_duration)

func _on_button_entrar_pressed() -> void:
	if entrando:
		return

	var email := email_input_login.text.strip_edges()
	var senha := senha_input_login.text  # A senha deve ser enviada como foi digitada.

	if email.is_empty() or senha.is_empty():
		mostrar_mensagem("Preencha todos os campos!")
		return

	if not verificar_email(email):
		mostrar_mensagem("E-mail inválido.")
		return

	entrando = true
	mostrar_mensagem("Conectando...")

	var dados := {"email": email, "senha": senha}
	var headers := PackedStringArray(["Content-Type: application/json"])

	# Login não envia Authorization: ele é quem obtém os primeiros tokens.
	var erro := http_request.request(
		URL_LOGIN,
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(dados)
	)

	if erro != OK:
		falhar_login("Não foi possível iniciar a conexão.")


func _on_login_response(
		result: int,
		response_code: int,
		_headers: PackedStringArray,
		body: PackedByteArray
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		falhar_login("Não foi possível conectar ao servidor.")
		return

	if response_code == 401:
		falhar_login("E-mail ou senha inválidos.")
		return

	var resposta = JSON.parse_string(body.get_string_from_utf8())

	if response_code != 200:
		var mensagem: String = "Erro ao fazer login (HTTP %d)." % response_code

		if resposta is Dictionary:
			var erros = resposta.get("erros")
			if erros is Array and not erros.is_empty():
				mensagem = str(erros[0])
			elif resposta.get("mensagem") is String:
				mensagem = resposta["mensagem"]

		falhar_login(mensagem)
		return

	if not (resposta is Dictionary):
		falhar_login("O servidor retornou uma resposta de login inválida.")
		return

	# 1. Guarda acessToken, refreshToken e userDados no global Sessao.
	# Isso precisa acontecer ANTES do GET /jogo, pois Api usa Sessao.access_token.
	if not Sessao.carregar_do_login(resposta):
		falhar_login("O login não retornou os tokens ou os dados do jogador.")
		return

	Api.registrar_login()

	# 2. O catálogo vem de uma rota separada.
	mostrar_mensagem("Carregando as fases...")
	var catalogo: Dictionary = await Api.buscar("/jogo")

	if not catalogo["ok"]:
		falhar_login("Não foi possível carregar o jogo. " + str(catalogo["mensagem"]))
		return

	# "dados" aqui é a chave criada pelo Api.gd para o corpo da resposta HTTP.
	# Seu conteúdo já é o JogoResponseDto: {trilhas, conquistas, itens}.
	var jogo = catalogo["dados"]
	if not (jogo is Dictionary):
		falhar_login("O catálogo do jogo veio em formato inválido.")
		return

	if not DadosJogo.carregar_catalogo(jogo):
		falhar_login("Não foi possível organizar as trilhas, conquistas e itens.")
		return

	# 3. A homepage já pode acessar Sessao e DadosJogo.
	abrir_home()


func abrir_home() -> void:
	mostrar_mensagem("Entrando...")
	var erro := get_tree().change_scene_to_file("res://homepage.tscn")
	if erro != OK:
		falhar_login("Não foi possível abrir a página inicial.")


func mostrar_mensagem(texto: String) -> void:
	label_mensagem_login.text = texto
	label_mensagem_login.visible = true


func falhar_login(texto: String) -> void:
	entrando = false
	mostrar_mensagem(texto)


func _on_button_cadastro_pressed() -> void:
	if not entrando:
		get_tree().change_scene_to_file("res://cadastro.tscn")


func _on_button_senha_pressed() -> void:
	senha_input.secret = not senha_input.secret
	botao_senha_login.icon = icone_olho_fechado if senha_input_login.secret else icone_olho_aberto


func _on_button_pressed():
	var nome = nome_input.text.strip_edges()
	var email = email_input.text.strip_edges()
	var senha = senha_input.text.strip_edges()
	
	label_mensagem.visible = false
	
	# Validação local no Godot (evita gastar a rede se faltar algo)
	if nome.is_empty() or email.is_empty() or senha.is_empty():
		label_mensagem.visible = true
		label_mensagem.text = "Preencha todos os campos!"
		return
	
	if not verificar_email(email):
		label_mensagem.text = "Email inválido"
		label_mensagem.visible = true
		return
	
	if senha.length() < 6:
		label_mensagem.visible = true
		label_mensagem.text = "A senha deve ter no mínimo 6 caracteres"
		return
	
	#Colocar validação de regex do email
	
	label_mensagem.visible = true
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
	label_mensagem.visible = false
	print("result: ", result)
	print("response_code: ", response_code)
	print("headers: ", headers)
	print("body: ", body.get_string_from_utf8())
	var json = JSON.new()
	var error = json.parse(body.get_string_from_utf8())
	
	if error == OK:
		var resposta = json.get_data()
		
		# O Spring retorna 201 para recurso criado com sucesso
		if response_code == 201:
			label_mensagem.visible = true
			label_mensagem.text = "Conta criada com sucesso!"
			
			# Aguarda 1.5 segundos para o usuário ler a mensagem e troca para o Login
			await get_tree().create_timer(1.5).timeout
			get_tree().change_scene_to_file("res://login.tscn")
		else:
			# Exibe a mensagem enviada pelo servidor (ex: "E-mail já cadastrado")
			label_mensagem.visible = true
			label_mensagem.text = resposta.get("mensagem", "Erro ao cadastrar.")
	else:
		label_mensagem.visible = true
		label_mensagem.text = "Falha de comunicação com o servidor."

func _esconder_exibir_senha() -> void:
	if senha_input.secret == false:
		senha_input.secret = true
		botao_senha.icon = icone_olho_fechado
	else:
		senha_input.secret = false
		botao_senha.icon = icone_olho_aberto
		
func _on_button_login_pressed() -> void:
	get_tree().change_scene_to_file("res://login.tscn")
	
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
