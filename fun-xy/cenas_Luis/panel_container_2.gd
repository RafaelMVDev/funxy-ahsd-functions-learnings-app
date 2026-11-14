extends PanelContainer

@onready var sol = %TextureRectSol
@onready var lua = %TextureRectLua
@onready var texto_sol = %LabelClaro
@onready var texto_lua = %LabelEscuro
@onready var botao_claro = %FundoClaro
@onready var botao_escuro = %FundoEscuro

#var icon_sol_azul = preload("")
var icon_sol_branco = preload("res://images/icones/aparencia_sol_branco.svg")
var icon_lua_branca = preload("res://images/icones/tema_escuro_lua_branca.svg")
var icon_sol_azul = preload("res://images/icones/tema_claro_sol_azul.svg")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_button_pressed() -> void:
	"""var estilo_botao_claro: StyleBox = get_theme_stylebox(botao_claro)
	var estilo_botao_escuro: StyleBox = get_theme_stylebox(botao_escuro)
	if estilo_botao_claro.bg_color == Color("e5eefd"):
		sol.icon = icon_sol_branco
		estilo_botao_claro.bg_color = Color("1d3b91")
		#lua,icon = icon_lua_escura
		estilo_botao_escuro.bg_color = Color("e5eefd")
	else:
		sol.icon = icon_sol_azul
		estilo_botao_claro.bg_color = Color("e5eefd")
		#lua,icon = icon_lua_clara
		estilo_botao_escuro.bg_color = Color("1d3b91")"""
	pass


func _on_button_home_pressed() -> void:
	get_tree().change_scene_to_file("res://homepage.tscn")
	pass # Replace with function body.
