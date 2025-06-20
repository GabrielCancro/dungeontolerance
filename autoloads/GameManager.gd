extends Node

var GAME_SCENE_REF
var TARGET_CHOSSER_REF
var DEFIANCES_REF
var DICES_REF
var POWERGEM_REF
var INPUT_BLOCKER_REF
var PARTY_ABILITIES_REF
var PARTY_REF

var block_input_time = 0

func _process(delta: float) -> void:
	if !is_instance_valid(INPUT_BLOCKER_REF): return
	if block_input_time>0: 
		block_input_time-=delta
	else: 
		INPUT_BLOCKER_REF.visible = false
		set_process(false)

func on_end_turn():
	block_input(1)
	await DiceManager.clear_dices()
	await timeout(1)
	await DefianceManager.launch_trigger_to_all_defiances("on_end_turn")
	await timeout(1)
	await PartyManager.clear_shield()
	if DefianceManager.ALL_DEFIANCES.size()<=0:
		var result = await LevelManager.next_level()
		if !result: return
	await PartyManager.roll_party_dices()
	await DefianceManager.launch_trigger_to_all_defiances("on_start_turn")
	await timeout(.3)
	
func timeout(val):
	GameManager.block_input(val+0.2)
	await get_tree().create_timer(val).timeout

func show_target_chosser(target_type,condition_tags):
	TARGET_CHOSSER_REF.show_target_chosser(target_type,condition_tags)

func block_input(time):
	if !is_instance_valid(INPUT_BLOCKER_REF): return
	if block_input_time<time: block_input_time += time
	INPUT_BLOCKER_REF.visible = true
	set_process(true)

func change_scene(scene_name):
	get_tree().change_scene_to_file("res://scenes/"+scene_name+".tscn")

func show_popup(name_popup):
	var node = load("res://popups/"+name_popup+".tscn").instantiate()
	get_node("/root/Game/CLUI").add_child(node)
