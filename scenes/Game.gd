extends Control

const play_tutorial = true

func _ready() -> void:
	HintManager.init($Hint/HintPanel)
	$BtnAddDice.connect("button_down",DiceManager.add_random_dice)
	$BtnEndTurn.connect("button_down",GameManager.on_end_turn)
	GameManager.GAME_SCENE_REF = self
	GameManager.TARGET_CHOSSER_REF = $CLUI/TargetChosser
	GameManager.DEFIANCES_REF = $Defiances
	GameManager.DICES_REF = $Dices
	GameManager.POWERGEM_REF = $CLUI/PowerGem
	GameManager.INPUT_BLOCKER_REF = $CLUI/InputBlocker
	GameManager.PARTY_ABILITIES_REF = $Abilities
	PartyManager.update_abilities_ui()
	if play_tutorial: tuto_sequence()
	else: start_sequence()

func tuto_sequence():
	$Abilities.visible = false
	await GameManager.timeout(2)
	await $CLUI/Tutorial.show_tuto("welcome")
	await $CLUI/Tutorial.show_tuto("party")
	await PartyManager.roll_party_dices()
	await $CLUI/Tutorial.show_tuto("dices")
	await GameManager.timeout(1)
	await LevelManager._add_defiance("rat")
	await GameManager.timeout(1)
	await $CLUI/Tutorial.show_tuto("rat1")
	await $CLUI/Tutorial.show_tuto("rat2")
	await $CLUI/Tutorial.show_tuto("rat3")
	await $CLUI/Tutorial.show_tuto("rat4")
	await GameManager.timeout(1)
	await DefianceManager.ALL_DEFIANCES[0].node.on_destroy
	await GameManager.timeout(1.5)
	await $CLUI/Tutorial.show_tuto("good_work")
	$Abilities.visible = true
	await $CLUI/Tutorial.show_tuto("ability1")
	await $CLUI/Tutorial.show_tuto("power1")
	await GameManager.timeout(1)
	await GameManager.POWERGEM_REF.show_powergem()
	await GameManager.timeout(1)
	await $CLUI/Tutorial.show_tuto("power2")
	await $CLUI/Tutorial.show_tuto("end")
	await LevelManager._add_defiance("rat")
	await LevelManager._add_defiance("rat")
	
func start_sequence():
	await GameManager.timeout(1)
	await GameManager.POWERGEM_REF.show_powergem()
	await GameManager.timeout(1)
	await LevelManager.build_level()
	await GameManager.timeout(2)
	await PartyManager.roll_party_dices()
