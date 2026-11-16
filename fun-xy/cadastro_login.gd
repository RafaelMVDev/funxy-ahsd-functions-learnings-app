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
#@onready var http_request_login: HTTPRequest = $HTTPRequest_Login
@onready var botao_senha_login: Button = %ButtonSenha_Login


# Aponta para a nova rota da sua API Spring Boot
const URL_LOGIN := "/auth/login"
var URL_CADASTRO = "/auth/registro"
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
	print("oi")
	var email: String = email_input_login.text.strip_edges()
	var senha: String = senha_input_login.text
	print(email)
	print(senha)
	print("cu")
	if email.is_empty() or senha.is_empty():
		mostrar_mensagem("Preencha todos os campos!")
		return

	if not verificar_email(email):
		mostrar_mensagem("E-mail inválido.")
		return

	entrando = true
	mostrar_mensagem("Conectando...")

	var dados: Dictionary = {
		"email": email,
		"senha": senha
	}

	# O Api já adiciona a URL_BASE e os cabeçalhos necessários.
	# Não enviamos token porque esta é a requisição de login.
	var resultado: Dictionary = await Api.requisitar(
		HTTPClient.METHOD_POST,
		URL_LOGIN,
		JSON.stringify(dados),
		false
	)

	# Encaminha a resposta para a função responsável pelo restante do login.
	await _on_login_response(resultado)


func _on_login_response(resultado: Dictionary) -> void:
	if not resultado["ok"]:
		if resultado["codigo"] == 401:
			falhar_login("E-mail ou senha inválidos.")
		else:
			falhar_login(str(resultado["mensagem"]))
		return

	# O Api já converteu o corpo JSON para um Dictionary.
	var resposta = resultado["dados"]

	if not (resposta is Dictionary):
		falhar_login("O servidor retornou uma resposta de login inválida.")
		return

	# Guarda os tokens e os dados do jogador antes de consultar /jogo.
	if not Sessao.carregar_do_login(resposta):
		falhar_login("O login não retornou os tokens ou os dados do jogador.")
		return

	Api.registrar_login()
	
	# O catálogo vem de uma rota separada.
	mostrar_mensagem("Carregando as fases...")
	var catalogo: Dictionary = await Api.buscar("/jogo")

	if not catalogo["ok"]:
		falhar_login(
			"Não foi possível carregar o jogo. " + str(catalogo["mensagem"])
		)
		return

	var jogo = catalogo["dados"]

	if not (jogo is Dictionary):
		falhar_login("O catálogo do jogo veio em formato inválido.")
		return

	if not DadosJogo.carregar_catalogo(jogo):
		falhar_login("Não foi possível organizar as trilhas, conquistas e itens.")
		return
	
	"""
	print("===== Dados do player carregados! ===== ")
	print(Sessao.player)
	print("===== Dados do jogo carregados! ===== ")
	print("Trilhas existentes:")
	print(DadosJogo.trilhas)
	print("Conquistas existentes:")
	print(DadosJogo.conquistas)
	print("Itens existentes: ")
	print(DadosJogo.itens)
	"""
	# Os dados pessoais e o catálogo estão disponíveis nos globais.
	get_tree().change_scene_to_file("res://Trilha.tscn")
	#abrir_home()


func abrir_home() -> void:
	mostrar_mensagem("Entrando...")
	var erro := get_tree().change_scene_to_file("res://cenas_Luis/Conteudos.tscn")
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
	senha_input_login.secret = not senha_input_login.secret
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
	var resposta = await Api.requisitar(
		HTTPClient.METHOD_POST,
		URL_CADASTRO,json_body,
		false
		)
		
	await _on_cadastro_response(resposta)
	

func _on_cadastro_response(resposta: Dictionary) -> void:
	label_mensagem.visible = true

	if resposta["ok"] and resposta["codigo"] == 201:
		label_mensagem.text = "Conta criada com sucesso!"

		# Aguarda 1 segundo antes de abrir o login.
		await get_tree().create_timer(1.0).timeout
		_on_btn_go_to_login_pressed()
	else:
		var mensagem: String = resposta.get("mensagem", "")

		if mensagem.is_empty():
			mensagem = "Não foi possível confirmar o cadastro."

		label_mensagem.text = mensagem

func _esconder_exibir_senha() -> void:
	if senha_input.secret == false:
		senha_input.secret = true
		botao_senha.icon = icone_olho_fechado
	else:
		senha_input.secret = false
		botao_senha.icon = icone_olho_aberto
		
func _on_button_login_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas_Luis/Conteúdos.tscn")
	
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
