extends Node

# triggercodes: on_apply_dice
var ALL_DEFIANCES = []
const DEFIANCES = {
	"goblin":{"req":{"S":2,"D":5}, "abs":[] },
}
const ABILITIES = {
	"counterattack":{},
}

func get_random_defiance():
	randomize()
	var k = DEFIANCES.keys()[randi()%DEFIANCES.keys().size()]
	var data = DEFIANCES[k].duplicate(true)
	for r in DiceManager.COLORS.keys(): data.req[r] = randi()%10
	data["abs"].append( get_def_ability_data("counterattack",2) )
	data["abs"].append( get_def_ability_data("activation",2) )
	data["abs"].append( get_def_ability_data("shield",2) )
	return data

func get_def_ability_data(ab_code,ab_level):
	var ab_data = {"name":ab_code, "level":ab_level}
	if ab_code=="activation": ab_data.merge({"count":0,"max_count":max(2,7-ab_level)})
	if ab_code=="shield": ab_data.merge({"count":ab_level,"max_count":ab_level})
	return ab_data

func launch_all_triggers(launcher):
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
			await call(ab.name+"_"+launcher, ab, def_card)

func counterattack_on_apply_dice(ab_data, def_card):
	Effector.shake(ab_data.node)
	await GameManager.timeout(1)
	Effector.float_text("COUNTERATTACK",def_card.node.position,"NORMAL")
	await GameManager.timeout(.7)
	PartyManager.apply_damage(2)
	await GameManager.timeout(.5)

func condition_shield_on_pre_apply_dice(ab_data, def_card): 
	var dice = DiceManager.get_dice_drag() 
	return (dice && dice.type == "S")
	
func shield_on_pre_apply_dice(ab_data, def_card):
	Effector.shake(ab_data.node)
	await GameManager.timeout(1)
	var dice = DiceManager.get_dice_drag() 
	var amount = min(ab_data.count, dice.value)
	dice.value -= amount
	ab_data.count -= amount
	dice.update()
	def_card.node.update_abs()
	await GameManager.timeout(1)

func shield_on_start_turn(ab_data, def_card):
	if ab_data.count<ab_data.max_count: 
		Effector.shake(ab_data.node)
		await GameManager.timeout(.2)
	ab_data.count = ab_data.max_count
	def_card.node.update_abs()
