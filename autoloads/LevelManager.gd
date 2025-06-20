extends Node

var dungeon = 1
var room = 0
var max_rooms = 5

func init_dungeon():
	dungeon = SaveManager.DATA["prestige"]
	room = 0
	if dungeon==0: max_rooms = 0
	else: max_rooms = 2 + int(dungeon/2) #d1:2 #d2:3 #d3:3 #d4:4
	clean_ui()

func next_level():
	room += 1
	if room>max_rooms:
		SaveManager.DATA["prestige"] += 1
		SaveManager.DATA["expedition"] += 1
		SaveManager.save_store_data()
		GameManager.change_scene("Tabern")
		return false
	update_ui()
	for def in GameManager.DEFIANCES_REF.get_children(): def.queue_free()
	randomize()
	for i in room+1:
		var k = DefianceManager.DEFIANCES.keys().duplicate()
		k.shuffle()
		_add_defiance(k[0])
	return true

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
	Lang.set_text_vars([dungeon,room,max_rooms])
	var Label = get_node_or_null("/root/Game/DungeonInfo/Label")
	if Label: Label.text = Lang.get_text("info_dungeon_level")

func clean_ui():
	var Label = get_node_or_null("/root/Game/DungeonInfo/Label")
	if Label: Label.text = "-"
