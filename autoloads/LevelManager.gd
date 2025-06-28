extends Node

var level = 1
var room_index = 0
var max_rooms = 0

var DUNGEONS = [
	[], # Level 0 - TUTORIAL
	["BB","BB"], #Level 1 - rooms 2 - Basic enemies
	["B","DESTINE","BB","BBB"], #Level 2
	["BN","BNB","DESTINE","BB"], #Level 3
]

func init_dungeon():
	level = min(DUNGEONS.size()-1,SaveManager.DATA["prestige"])
	room_index = -1
	max_rooms = DUNGEONS[level].size()
	clean_ui()

func next_level():
	room_index += 1
	if room_index>=max_rooms:
		SaveManager.DATA["prestige"] += 1
		SaveManager.DATA["expedition"] += 1
		SaveManager.save_store_data()
		GameManager.show_popup("EndExpedition")
		return false
	for def in GameManager.DEFIANCES_REF.get_children(): def.queue_free()
	await Effector.transition_level_off()
	update_ui()
	if DUNGEONS[level][room_index]=="DESTINE":
		DestineManager.show_destine()
	else:
		await Effector.transition_level_on()
		for def_tag in DUNGEONS[level][room_index]:
			var key = DefianceManager.get_random_defiance_key_by_tag(def_tag)
			print("ADDING ",key," by tag ",def_tag)
			_add_defiance(key)
	return true

func is_now_in_destine():
	print("IS NOW IN DESTINE ",(DUNGEONS[level][room_index]=="DESTINE"))
	return (DUNGEONS[level][room_index]=="DESTINE")

func _add_defiance(def_type):
	if DefianceManager.ALL_DEFIANCES.size()>=5: 
		print("MANY DEFIANCES!!!!")
		return
	var node = preload("res://nodes/DefianceCard.tscn").instantiate()
	var def_data = DefianceManager.get_defiance_data(def_type)
	node.set_data(def_data)
	GameManager.DEFIANCES_REF.add_child(node)
	node.position = Vector2(1200,150)
	node.modulate.a = 0
	reorder_cards()

func reorder_cards():
	var all_def = DefianceManager.ALL_DEFIANCES
	if all_def.size() == 1: 
		await _move_def(all_def[0].node, 750, 180)
	elif all_def.size() == 2: 
		await _move_def(all_def[0].node, 700, 130)
		await _move_def(all_def[1].node, 850, 320)
	elif all_def.size() == 3: 
		await _move_def(all_def[0].node, 675, 105)
		await _move_def(all_def[1].node, 901, 359)
		await _move_def(all_def[2].node, 938, 97)
	elif all_def.size() == 4: 
		await _move_def(all_def[0].node, 596, 115)
		await _move_def(all_def[1].node, 802, 74)
		await _move_def(all_def[2].node, 983, 226)
		await _move_def(all_def[3].node, 774, 348)
	elif all_def.size() == 5: 
		await _move_def(all_def[0].node, 535, 113)
		await _move_def(all_def[1].node, 731, 64)
		await _move_def(all_def[2].node, 966, 104)
		await _move_def(all_def[3].node, 936, 361)
		await _move_def(all_def[4].node, 733, 351)

func _move_def(node,pox,posy):
	Effector.move_to(node, Vector2(pox,posy))
	Effector.appear_less(node)
	await GameManager.timeout(.3)

func update_ui():
	Lang.set_text_vars([level,room_index+1,max_rooms])
	var Label = get_node_or_null("/root/Game/DungeonInfo/Label")
	if Label: Label.text = Lang.get_text("info_dungeon_level")

func clean_ui():
	var Label = get_node_or_null("/root/Game/DungeonInfo/Label")
	if Label: Label.text = "-"
