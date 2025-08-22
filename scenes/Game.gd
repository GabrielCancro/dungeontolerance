extends Control

func _ready() -> void:
	HintManager.init($Hint/HintPanel)
	$BtnAddDice.connect("button_down",DiceManager.add_random_dice)
	$BtnEndTurn.connect("button_down",GameManager.on_end_turn)
	$BtnLeave.connect("button_down",on_leave_ruins)
	$BtnAddEnemy.connect("button_down",LevelManager.add_defiance.bind("rat"))
	$CLUI/Tutorial.connect("on_skip_tutorial",on_skip_tuto)
	GameManager.GAME_SCENE_REF = self
	GameManager.TARGET_CHOSSER_REF = $CLUI/TargetChosser
	GameManager.DEFIANCES_REF = $Defiances
	GameManager.DICES_REF = $Dices
	GameManager.POWERGEM_REF = $PowerGem
	GameManager.INPUT_BLOCKER_REF = $CLUI/InputBlocker
	GameManager.PARTY_REF = $Party
	GameManager.PARTY_ABILITIES_REF = $Abilities
	GameManager.PARTY_ITEMS_REF = $Items
	GameManager.DESTINE_REF = $DestinePopup
	GameManager.BG_IMAGE_REF = $CLBG/TextureRect
	$CLBG/TextureRect.modulate.a = 0
	$Dices.modulate.a = 0
	$DefShadow.modulate.a = 0
	PartyManager.update_abilities_ui()
	PartyManager.update_items_ui()
	PartyManager.restore_hp()
	LevelManager.init_dungeon()
	if LevelManager.level==0: tuto_sequence()
	else: start_sequence()

func tuto_sequence():
	$Abilities.visible = false
	$EyeTrack.visible = false
	$CLBG/TextureRect.modulate.a = 1
	$Dices.modulate.a = 1
	await GameManager.timeout(2)
	await $CLUI/Tutorial.show_tuto("welcome")
	await $CLUI/Tutorial.show_tuto("party")
	if !get_tree(): return
	await PartyManager.roll_party_dices()
	await $CLUI/Tutorial.show_tuto("dices")
	if !get_tree(): return
	await GameManager.timeout(1)
	await LevelManager.add_defiance("tuto_rat")
	await GameManager.timeout(1)
	await $CLUI/Tutorial.show_tuto("rat1")
	await $CLUI/Tutorial.show_tuto("rat2")
	await $CLUI/Tutorial.show_tuto("rat3")
	if !get_tree(): return
	await GameManager.timeout(1)
	PartyManager.add_shield(1)
	await $CLUI/Tutorial.show_tuto("shield")
	await $CLUI/Tutorial.show_tuto("rat4")
	if !get_tree(): return
	await DefianceManager.ALL_DEFIANCES[0].node.on_destroy
	await GameManager.timeout(1.5)
	await $CLUI/Tutorial.show_tuto("good_work")
	if !get_tree(): return
	$Abilities.visible = true
	await $CLUI/Tutorial.show_tuto("ability1")
	await $CLUI/Tutorial.show_tuto("power1")
	if !get_tree(): return
	await GameManager.timeout(1)
	await GameManager.POWERGEM_REF.show_powergem()
	await GameManager.timeout(1)
	await $CLUI/Tutorial.show_tuto("power2")
	await $CLUI/Tutorial.show_tuto("end")
	if !get_tree(): return
	DiceManager.remove_dices()
	await LevelManager.add_defiance("tuto_rat")
	await LevelManager.add_defiance("tuto_rat")
	if !get_tree(): return
	await PartyManager.roll_party_dices()
	
func start_sequence():
	await GameManager.on_start_game()

func on_skip_tuto():
	SaveManager.DATA["prestige"] = 1
	SaveManager.save_store_data()
	GameManager.change_scene("Tabern")

func on_leave_ruins():
	GameManager.change_scene("Tabern")
