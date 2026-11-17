extends PanelContainer
# Criado nesta refatoração: apresenta a navegação compartilhada.
# As ações continuam conectadas às funções existentes em cada tela.
signal trilhas_pressed
signal conteudos_pressed
signal ranking_pressed
signal perfil_pressed
signal ajustes_pressed
@export_range(0, 4) var aba_ativa: int = 0

# Criada nesta refatoração: padroniza estados visuais e encaminha os cliques.
func _ready() -> void:
	var sinais: Array[StringName] = [&"trilhas_pressed", &"conteudos_pressed", &"ranking_pressed", &"perfil_pressed", &"ajustes_pressed"]
	for i in range($Margem/Abas.get_child_count()):
		var botao: Button = $Margem/Abas.get_child(i)
		var selecionado: bool = i == aba_ativa
		var cor: Color = Color("245fe5") if selecionado else Color("64748b")
		var estilo := StyleBoxFlat.new()
		estilo.bg_color = Color("eaf1ff") if selecionado else Color.TRANSPARENT
		estilo.set_corner_radius_all(12)
		botao.add_theme_stylebox_override("normal", estilo)
		var hover: StyleBoxFlat = estilo.duplicate()
		hover.bg_color = Color("edf2f9")
		botao.add_theme_stylebox_override("hover", hover)
		botao.add_theme_stylebox_override("pressed", hover)
		var foco: StyleBoxFlat = estilo.duplicate()
		foco.bg_color = Color.TRANSPARENT
		foco.border_color = Color("245fe5")
		foco.set_border_width_all(2)
		botao.add_theme_stylebox_override("focus", foco)
		botao.get_node("Icone").self_modulate = cor
		botao.get_node("Legenda").add_theme_color_override("font_color", cor)
		botao.pressed.connect(_emitir_aba.bind(sinais[i]))

# Criada nesta refatoração: emite o sinal; não modifica sessão nem progresso.
func _emitir_aba(nome_sinal: StringName) -> void:
	emit_signal(nome_sinal)
