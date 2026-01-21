extends Node

var level = 1
var room_index = 0
var max_rooms = 0

#B:rat,bat   N:goblin  S:slime,   T:chest   #C:traps
#var DUNGEONS = [
	#[], # Level 0 - TUTORIAL
	#["BB","BB","CBB","BBB"], #Level 1 - rooms 4 - Basic enemies
	#["CBN","BNBT","DESTINE","BCN","BBB","BNB"], #Level 2
	#["BN","BNC","DESTINE","BNBB","TNBC","BNN","BCBN"], #Level 3
#]

var DUNGEONS = [
	# Level 0 - TUTORIAL
	[], 
	
	# Level 1
	[
	#"skeleton + skeleton + skeleton + skeleton_king",
	#"DESTINE:old_chest",
	#"DESTINE:campfire",
	#"DESTINE:end_level",
	#"DESTINE:fail_level",
	"rat/bat + rat/bat",
	"rat/bat + rat/bat + chest"],
	
	# Level 2
	["rat/bat + rat/bat + arrow_trap", 
	"rat/bat + rat/bat + goblin + chest",
	"rat/bat + goblin"], 
	
	# Level 3
	["rat/bat + goblin + chest + arrow_trap",
	"DESTINE:campfire",
	"rat/bat + rat/bat + arrow_trap",
	"goblin + goblin + chest"],
	
	# Level 4
	["rat/bat + slime + rune_trap",
	"rat/bat + slime + arrow_trap + chest",
	"rat/bat + rat/bat + rat/bat + rat/bat",
	"slime + chest"],

	# Level 5
	["rat/bat + spider + arrow_trap",
	"spider + slime + spider + chest",
	"DESTINE:old_chest",
	"spider + spider + spider + chest"],

	# Level 6
	["spider + goblin + arrow_trap",
	"rat/bat + slime + rune_trap + chest",
	"DESTINE:campfire",
	"skeleton + skeleton + skeleton_king"],
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
		DestineManager.show_destine("end_level")
		return false
	for def in GameManager.DEFIANCES_REF.get_children(): def.queue_free()
	DefianceManager.ALL_DEFIANCES = []
	Sounds.play_sound("boot_steps")
	await Effector.transition_level_off()
	update_ui()
	#DUNGEONS[level][room_index]="C"
	if "DESTINE:" in DUNGEONS[level][room_index]:
		DestineManager.show_destine( DUNGEONS[level][room_index].split(":")[1] )
	else:
		await Effector.transition_level_on()
		var room_arr = (DUNGEONS[level][room_index] as String).split(" + ")
		for def_tags in room_arr:
			var keys = def_tags.split("/")
			var key = keys[ randi() % keys.size() ]
			#var key = DefianceManager.get_random_defiance_key_by_tag(def_tag)
			print("ADDING ",key," by tag ",key)
			await get_tree().create_timer(.5).timeout
			add_defiance(key)
		await get_tree().create_timer(.5).timeout
	return true

func is_now_in_destine():
	if room_index < 0: return false
	if room_index >=DUNGEONS[level].size(): return false
	print("IS NOW IN DESTINE ",("DESTINE" in DUNGEONS[level][room_index]))
	return ("DESTINE" in DUNGEONS[level][room_index])

func add_defiance(def_type):
	if DefianceManager.ALL_DEFIANCES.size()>=5: 
		print("MANY DEFIANCES!!!!")
		return
	var node = preload("res://nodes/DefianceCard.tscn").instantiate()
	var def_data = DefianceManager.get_defiance_data(def_type)
	node.set_data(def_data)
	GameManager.DEFIANCES_REF.add_child(node)
	node.position = Vector2(1200,150)
	node.modulate.a = 0
	Sounds.play_sound("card_move")
	Effector.appear_less(node)
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
	await GameManager.timeout(.3)

func update_ui():
	Lang.set_text_vars([level,room_index+1,max_rooms])
	var Label = get_node_or_null("/root/Game/DungeonInfo/Label")
	if Label: Label.text = Lang.get_text("info_dungeon_level")

func clean_ui():
	var Label = get_node_or_null("/root/Game/DungeonInfo/Label")
	if Label: Label.text = "-"
