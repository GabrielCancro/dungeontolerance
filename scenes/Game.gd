extends Control

func _ready() -> void:
	HintManager.init($Hint/HintPanel)
	HintManager.set_text("assad sdasdq erqerqrefadfjd fn kjdfksdbfid bfkdbsf khsdbfkj sd")
	$BtnAddDice.connect("button_down",DiceManager.add_random_dice)
	$BtnEndTurn.connect("button_down",GameManager.on_end_turn)
	GameManager.init(self)
