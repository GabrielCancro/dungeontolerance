extends Node

var GAME_SCENE

func init(_scene):
	GAME_SCENE = _scene

func on_end_turn():
	await DefianceManager.launch_all_triggers("on_end_turn")
	DiceManager.clear_dices()
	
