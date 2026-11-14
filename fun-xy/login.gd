extends Control

const URL_LOGIN := "http://localhost:8080/auth/login"
const ICONE_OLHO_ABERTO := preload("res://images/icones/olho.svg")
const ICONE_OLHO_FECHADO := preload("res://images/olho-fechado.svg")

@onready var email_input: LineEdit = %LineEdit_EmailUsuario
@onready var senha_input: LineEdit = %LineEdit_Senha
@onready var label_mensagem: Label = %Label_Mensagem
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var botao_senha: Button = %ButtonSenha

# Evita dois logins se o jogador clicar em Entrar mais de uma vez.
var entrando := false


func _ready() -> void:
	http_request.timeout = 10.0

	if not http_request.request_completed.is_connected(_on_login_response):
		http_request.request_completed.connect(_on_login_response)

	# A tela acabou de abrir. Ainda não precisamos de nenhum token.
	entrando = false
	label_mensagem.visible = false
	"""
	http_request.timeout = 10.0

	# Funciona mesmo se o sinal já tiver sido conectado pelo editor.
	if not http_request.request_completed.is_connected(_on_login_response):
		http_request.request_completed.connect(_on_login_response)

	# Se houver um refresh token salvo, tenta entrar sem pedir a senha.
	entrando = true
	mostrar_mensagem("Verificando sessão...")

	var resultado: Dictionary = await Api.restaurar_sessao()
	print(resultado)
	if resultado.ok:
		abrir_home()
		return

	entrando = false

	if resultado.codigo == 401:
		# Primeiro acesso, login não salvo ou sessão expirada.
		# Deixa o formulário disponível, sem mostrar erro de senha.
		label_mensagem.visible = false
	else:
		mostrar_mensagem("Não foi possível restaurar a sessão. Verifique sua conexão.")
"""

func _on_button_entrar_pressed() -> void:
	if entrando:
		return

	var email: String = email_input.text.strip_edges()
	var senha: String = senha_input.text

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
	var resultado: Dictionary = await Api._enviar(
		HTTPClient.METHOD_POST,
		"/auth/login",
		JSON.stringify(dados)
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

	# Os dados pessoais e o catálogo estão disponíveis nos globais.
	abrir_home()


func abrir_home() -> void:
	mostrar_mensagem("Entrando...")
	var erro := get_tree().change_scene_to_file("res://homepage.tscn")
	if erro != OK:
		falhar_login("Não foi possível abrir a página inicial.")


func mostrar_mensagem(texto: String) -> void:
	label_mensagem.text = texto
	label_mensagem.visible = true


func falhar_login(texto: String) -> void:
	entrando = false
	mostrar_mensagem(texto)


func _on_button_cadastro_pressed() -> void:
	if not entrando:
		get_tree().change_scene_to_file("res://cadastro.tscn")


func _on_button_senha_pressed() -> void:
	senha_input.secret = not senha_input.secret
	botao_senha.icon = ICONE_OLHO_FECHADO if senha_input.secret else ICONE_OLHO_ABERTO


func verificar_email(email: String) -> bool:
	var regex := RegEx.new()
	regex.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")
	return regex.search(email) != null
