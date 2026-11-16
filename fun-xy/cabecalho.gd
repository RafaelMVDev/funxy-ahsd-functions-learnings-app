extends PanelContainer

@onready var label_moedas: Label = %MoedasLabel
@onready var label_xp: Label = %XpLabel
@onready var label_streak: Label = %StreakLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	carregar_cabeçalho()
	pass # Replace with function body.

func carregar_cabeçalho() -> void:
	var xp = Sessao.player["xp"]
	var moedas = Sessao.player["moedas"]
	var streak = Sessao.player["sequencia"]
	
	if xp:
		label_xp.text = str(int(xp))
	else:
		label_xp.text = '0'
		
	if moedas:
		label_moedas.text = str(int(moedas))
	else: 
		label_moedas.text = "0"
		
	if streak:
		label_streak.text = str(int(streak))
	else:
		label_streak.text = '1'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
