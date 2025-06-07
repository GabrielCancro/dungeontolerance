extends Control

func _ready() -> void:
	$BtnAddDice.connect("button_down",DiceManager.add_random_dice)
