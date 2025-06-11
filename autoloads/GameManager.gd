extends Node

var GAME_SCENE

func init(_scene):
	GAME_SCENE = _scene

func on_end_turn():
	await DefianceManager.launch_all_triggers("on_end_turn")
	DiceManager.clear_dices()
	await timeout(1)
	for i in range(5): DiceManager.add_random_dice()
	await timeout(1.5)
	await DefianceManager.launch_all_triggers("on_start_turn")
	
func timeout(val):
	await get_tree().create_timer(val).timeout
