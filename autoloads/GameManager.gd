extends Node

var GAME_SCENE_REF
var TARGET_CHOSSER_REF
var DEFIANCES_REF
var DICES_REF
var POWERGEM_REF

func on_end_turn():
	await DefianceManager.launch_all_triggers("on_end_turn")
	DiceManager.clear_dices()
	await timeout(1)
	for i in range(5): DiceManager.add_random_dice()
	await timeout(1.5)
	await DefianceManager.launch_all_triggers("on_start_turn")
	
func timeout(val):
	await get_tree().create_timer(val).timeout

func show_target_chosser(target_type,condition_tags):
	TARGET_CHOSSER_REF.show_target_chosser(target_type,condition_tags)
