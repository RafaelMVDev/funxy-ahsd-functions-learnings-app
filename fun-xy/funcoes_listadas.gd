extends VBoxContainer

#Cria um panel com Label dentro para cada funcao
#Cria um funcao chamda pelo pai com o sinal


func _ready() -> void:
	pass # Replace with function body.

func exibir_funcoes(expressao: String) -> void:
	var funcao = " f(x): " + expressao
	var painel_individual = PanelContainer.new()
	var label = Label.new()
	var estilo = StyleBoxFlat.new()
			
	painel_individual.custom_minimum_size = Vector2(200, 25)
	label.text = funcao
	
	estilo.bg_color = Color("#353949")
	estilo.bg_color.a = 1.0
	
	painel_individual.add_theme_stylebox_override("panel", estilo)
	painel_individual.add_child(label)
	add_child(painel_individual)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
