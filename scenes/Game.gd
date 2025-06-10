extends Control

func _ready() -> void:
	HintManager.init($Hint/HintPanel)
	HintManager.set_text("assad sdasdq erqerqrefadfjd fn kjdfksdbfid bfkdbsf khsdbfkj sd")
	$BtnAddDice.connect("button_down",DiceManager.add_random_dice)
	GameManager.init(self)
