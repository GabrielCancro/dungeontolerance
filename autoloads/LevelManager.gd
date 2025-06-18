extends Node

var dungeon = 1
var room = 0
var max_rooms = 5

func next_level():
	room += 1
	update_ui()
	for def in GameManager.DEFIANCES_REF.get_children(): def.queue_free()
	randomize()
	for i in room+1:
		var k = DefianceManager.DEFIANCES.keys().duplicate()
		k.shuffle()
		_add_defiance(k[0])

func _add_defiance(def_type):
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

func _move_def(node,pox,posy):
	Effector.move_to(node, Vector2(pox,posy))
	Effector.appear_less(node)
	await GameManager.timeout(.3)

func update_ui():
	Lang.set_text_vars([dungeon,room,max_rooms])
	get_node("/root/Game/DungeonInfo/Label").text = Lang.get_text("info_dungeon_level")
