extends Node

# triggercodes: on_apply_dice
var TRIGGERS = ["on_end_turn", "on_start_turn", "on_apply_dice", "on_pre_apply_dice", "on_dead_defiance"]
var ALL_DEFIANCES = []
const DEFIANCES = {
	"tuto_rat":{     "hp":6 , "stats":{"S":2,"D":1,"M":0}, "tags":"", 
		"abs":[ "aggressive*3" ] },
	"goblin":{  "hp":9, "stats":{"S":2,"D":3,"M":1}, "tags":"N",
		"abs":["aggressive*4","counterattack*2"] },
	"rat":{     "hp":7 , "stats":{"S":2,"D":2,"M":3}, "tags":"B", 
		"abs":[ "aggressive*3" ] }, #"shield*2",
	"bat":{     "hp":6 , "stats":{"S":3,"D":1,"M":3}, "tags":"B", 
		"abs":[ "drainer*1","aggressive*3" ] },
	"chest":{     "hp":6 , "stats":{"S":4,"D":2,"M":4}, "tags":"T", 
		"abs":[ "teasure*1" ] },
	"arrow_trap":{"hp":7 , "stats":{"S":8,"D":1,"M":5}, "tags":"C", 
		"abs":[ "activation*3", "trap_damage*10" ] },
	"slime":{"hp":8 , "stats":{"S":3,"D":3,"M":1}, "tags":"S", 
		"abs":[ "aggressive*4","absorb*1" ] },
	"ghost":{"hp":4 , "stats":{"S":3,"D":2,"M":2}, "tags":"-",
		"abs":[ "necrotic*3"] },
	"spider":{"hp":8 , "stats":{"S":3,"D":2,"M":3}, "tags":"-", 
		"abs":[ "aggressive*3","poison*1" ] },
	"rune_trap":{"hp":7 , "stats":{"S":8,"D":5,"M":1}, "tags":"C", 
		"abs":[ "activation*3", "trap_sanity*3" ] },
	"skeleton":{  "hp":10, "stats":{"S":2,"D":1,"M":1}, "tags":"N",
		"abs":["aggressive*4"] },
	"skeleton_king":{  "hp":18, "stats":{"S":2,"D":2,"M":2}, "tags":"N", "boss":true,
		"abs":["aggressive*4","nigromant*2"] },
}

const ignored_trigger_resalt = [
	"counterattack_on_end_turn"
]
func get_defiance_data(def_code,level=1):
	var data = DEFIANCES[def_code].duplicate(true)
	data.hp = randi_range(data.hp,data.hp*1.2)
	data["name"] = def_code
	
	#GET ABILITIES DATA
	var abs_array = data.abs.duplicate()
	data.abs.clear()
	for a in abs_array:
		var spl = a.split("*") #ab_name*level
		data["abs"].append( get_def_ability_data(spl[0],int(spl[1])) )
	return data

func get_random_defiance():
	randomize()
	var k = DEFIANCES.keys()[randi()%DEFIANCES.keys().size()]
	return get_defiance_data(k)

func get_random_defiance_key_by_tag(def_tag):
	randomize()
	var all_keys = DEFIANCES.keys()
	all_keys.shuffle()
	for key in all_keys:
		if def_tag in DEFIANCES[key]["tags"]: return key
	return null

func get_def_ability_data(ab_code,ab_level):
	#active..reload on start turn
	var ab_data = {"name":ab_code, "level":ab_level}
	if ab_code=="counterattack": ab_data.merge({"min":floor(ab_level/2),"max":ab_level, "active":true})
	if ab_code=="aggressive": ab_data.merge({"min":floor(ab_level/2),"max":ab_level})
	if ab_code=="necrotic": ab_data.merge({"min":floor(ab_level/2),"max":ab_level})
	if ab_code=="trap_damage": ab_data.merge({"min":floor(ab_level/2),"max":ab_level})
	if ab_code=="activation": ab_data.merge({"count":0,"max_count":ab_level})
	if ab_code=="shield": ab_data.merge({"count":ab_level,"max_count":ab_level})
	if ab_code=="absorb": ab_data.merge({"active":true}) 
	return ab_data

func launch_trigger_to_all_defiances(launcher):
	for def in ALL_DEFIANCES: 
		await launch_trigger(launcher,def)
	await GameManager.timeout(.2)

func launch_trigger(launcher, def_card):
	if !is_instance_valid(def_card.node): return
	if def_card.node.is_dead() and launcher!="on_dead_defiance": return
	# on_apply_dice on_pre_appliy_dice
	for ab in def_card["abs"]:
		if "active" in ab and ab["active"]==false and launcher=="on_start_turn":
			ab["active"] = true
			ab.node.resalt()
			def_card.node.update_abs()
			await GameManager.timeout(.5)
		if has_method(ab.name+"_"+launcher): 
			if has_method("condition_"+ab.name+"_"+launcher): 
				if !call("condition_"+ab.name+"_"+launcher, ab, def_card): continue
			if launcher=="on_apply_dice": await GameManager.timeout(1)
			print("LAUNCHING TRIGGER ",launcher,"->",def_card.name)
			if !"active" in ab or ab["active"]:
				if !ab.name+"_"+launcher in ignored_trigger_resalt:
					def_card.node.ligth(true)
			await GameManager.timeout(0.6)
			await call(ab.name+"_"+launcher, ab, def_card)
			if is_instance_valid(def_card.node): def_card.node.ligth(false)
			else: Effector.hide_defiance_shadow()
			await GameManager.timeout(0.3)
	await GameManager.timeout(0.1)

func counterattack_on_apply_dice(ab_data, def_card):
	if !ab_data["active"]: return
	ab_data["active"] = false
	ab_data.node.resalt()
	await GameManager.timeout(.7)
	randomize()
	var damage = randi_range(ab_data.min,ab_data.max)
	await PartyManager.apply_damage(damage,def_card)
	def_card.node.update_abs()
	await GameManager.timeout(.5)

func condition_shield_on_pre_apply_dice(ab_data, def_card): 
	var dice = DiceManager.get_dice_drag() 
	return (dice && dice.type == "S")
	
func shield_on_pre_apply_dice(ab_data, def_card):
	ab_data.node.resalt()
	await GameManager.timeout(1)
	var dice = DiceManager.get_dice_drag() 
	var amount = min(ab_data.count, dice.value)
	dice.set_value(dice.value-amount)
	ab_data.count -= amount
	dice.update()
	def_card.node.update_abs()
	await GameManager.timeout(1)

func shield_on_start_turn(ab_data, def_card):
	if ab_data.count<ab_data.max_count: 
		ab_data.node.resalt()
		await GameManager.timeout(.2)
	ab_data.count = ab_data.max_count
	def_card.node.update_abs()

func aggressive_on_end_turn(ab_data, def_card):
	ab_data.node.resalt()
	await GameManager.timeout(.5)
	randomize()
	await PartyManager.apply_damage(randi_range(ab_data.min,ab_data.max),def_card)
	await GameManager.timeout(.5)

func necrotic_on_end_turn(ab_data, def_card):
	ab_data.node.resalt()
	await GameManager.timeout(.5)
	randomize()
	await PartyManager.apply_direct_damage(randi_range(ab_data.min,ab_data.max),def_card)
	await GameManager.timeout(.5)

func drainer_on_end_defiance_attack(ab_data, def_card):
	await GameManager.timeout(.7)
	ab_data.node.resalt()
	await GameManager.timeout(.5)
	def_card.node.heal_defiance(ab_data.level)
	await GameManager.timeout(.5)

func teasure_on_dead_defiance(ab_data, def_card):
	await GameManager.timeout(.7)
	randomize()
	var key = PartyManager.get_rnd_item()
	var texture = load("res://assets/abilities/ab_"+key+".png")
	Effector.texture_from_to(texture,ab_data.node.global_position+ab_data.node.size/2+Vector2(0,-100),Vector2(25,5),Vector2(1,1),Vector2(.5,.5))
	Sounds.play_sound("openchest")
	await GameManager.timeout(1)
	PartyManager.add_item(key)

func activation_on_end_turn(ab_data, def_card):
	await GameManager.timeout(.7)
	ab_data.count = min(ab_data.count+1,ab_data.max_count)
	ab_data.node.resalt()
	Sounds.play_sound("timer_tictac")
	def_card.node.update_abs()
	await GameManager.timeout(.7)
	if ab_data.count==ab_data.max_count:
		await launch_trigger("on_activate",def_card)
		await GameManager.timeout(.5)
		await def_card.node.discard()

func trap_damage_on_activate(ab_data, def_card):
	ab_data.node.resalt()
	await GameManager.timeout(.5)
	randomize()
	await PartyManager.apply_damage(randi_range(ab_data.min,ab_data.max),def_card)
	await GameManager.timeout(.8)

func trap_sanity_on_activate(ab_data, def_card):
	ab_data.node.resalt()
	await GameManager.timeout(.5)
	randomize()
	await PartyManager.dec_sanity(ab_data.level)
	await GameManager.timeout(.8)

func poison_on_end_defiance_attack(ab_data, def_card):
	ab_data.node.resalt()
	await GameManager.timeout(.5)
	PartyManager.dec_sanity()
	await GameManager.timeout(.5)

func absorb_on_pre_apply_dice(ab_data, def_card):
	if !ab_data["active"]: return
	ab_data["active"] = false
	ab_data.node.resalt()
	DiceManager.current_dice_drag.set_value(0)
	def_card.node.update_abs()
	await GameManager.timeout(.5)

func nigromant_on_end_turn(ab_data, def_card):
	var counter = 0
	for def in ALL_DEFIANCES:
		if def["name"] == "skeleton": counter+=1
	await GameManager.timeout(.55)
	ab_data.node.resalt()
	for i in range(counter):
		await GameManager.timeout(.8)
		def_card.node.heal_defiance(ab_data["level"])
	await GameManager.timeout(.5)
