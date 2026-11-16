extends Control

@onready var label_moeda: Label = %Label_Moeda
@onready var label_xp: Label = %Label_XP
@onready var label_sequencia: Label = %Label_Sequencia

var valor_moedas_label = str(Sessao.player['moedas'])
var valor_xp_label = str(Sessao.player['xp'])
var valor_sequencia_label = str(Sessao.player['sequencia'])

func _ready() -> void:
	label_moeda.text = valor_moedas_label
	label_moeda.visible = true
	label_xp.text = valor_xp_label
	label_xp.visible = true
	label_sequencia.text = valor_sequencia_label
	label_sequencia.visible = true

func _on_texture_button_configuracoes_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas_Luis/Configuracoes.tscn")
