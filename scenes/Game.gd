extends Control

func _ready() -> void:
	HintManager.init($Hint/HintPanel)
	$BtnAddDice.connect("button_down",DiceManager.add_dice)
	$BtnEndTurn.connect("button_down",GameManager.on_end_turn)
	GameManager.GAME_SCENE_REF = self
	GameManager.TARGET_CHOSSER_REF = $CLUI/TargetChosser
	GameManager.DEFIANCES_REF = $Defiances
	GameManager.DICES_REF = $Dices
	GameManager.POWERGEM_REF = $CLUI/PowerGem
	GameManager.INPUT_BLOCKER_REF = $CLUI/InputBlocker
	await LevelManager.build_level()
	await PartyManager.roll_party_dices() 
