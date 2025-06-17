extends Node

# triggercodes: on_apply_dice
var TRIGGERS = ["on_end_turn", "on_start_turn", "on_apply_dice", "on_pre_apply_dice"]
var ALL_DEFIANCES = []
const DEFIANCES = {
	"goblin":{  "hp":10, "stats":{"S":2,"D":5,"M":3}, "abs":[] },
	"rat":{     "hp":7 , "stats":{"S":2,"D":2,"M":3}, "abs":[ "aggressive*2" ] }, #"shield*2",
	"bat":{     "hp":5 , "stats":{"S":3,"D":1,"M":3}, "abs":[ "drainer*1","aggressive*2" ] },
}

func get_defiance_data(def_code,level=1):
	var data = DEFIANCES[def_code].duplicate(true)
	data.hp = randi_range(data.hp*0.8,data.hp*1.2)
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

func get_def_ability_data(ab_code,ab_level):
	var ab_data = {"name":ab_code, "level":ab_level}
	if ab_code=="activation": ab_data.merge({"count":0,"max_count":max(2,7-ab_level)})
	if ab_code=="shield": ab_data.merge({"count":ab_level,"max_count":ab_level})
	return ab_data

func launch_trigger_to_all_defiances(launcher):
	for def in ALL_DEFIANCES: 
		await launch_trigger(launcher,def)
	await GameManager.timeout(.2)

func launch_trigger(launcher, def_card):
	# on_apply_dice on_pre_appliy_dice
	for ab in def_card["abs"]:
		if has_method(ab.name+"_"+launcher): 
			if has_method("condition_"+ab.name+"_"+launcher): 
				if !call("condition_"+ab.name+"_"+launcher, ab, def_card): continue
			if launcher=="on_apply_dice": await GameManager.timeout(1)
			def_card.node.ligth(true)
			await call(ab.name+"_"+launcher, ab, def_card)
			def_card.node.ligth(false)
	await GameManager.timeout(0.1)

func counterattack_on_apply_dice(ab_data, def_card):
	ab_data.node.resalt()
	await GameManager.timeout(.7)
	#Effector.float_text("COUNTERATTACK",def_card.node.position,"NORMAL")
	#await GameManager.timeout(.4)
	randomize()
	await PartyManager.apply_damage(randi_range(0,ab_data.level),def_card.node)
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
	await PartyManager.apply_damage(ab_data.level,def_card)
	await GameManager.timeout(.5)

func drainer_on_end_defiance_attack(ab_data, def_card):
	await GameManager.timeout(.7)
	ab_data.node.resalt()
	await GameManager.timeout(.5)
	def_card.node.heal_defiance(1)
	await GameManager.timeout(.5)
