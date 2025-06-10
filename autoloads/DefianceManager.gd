extends Node

# triggercodes: on_apply_dice
var ALL_DEFIANCES = []
const DEFIANCES = {
	"goblin":{"req":{"S":2,"D":5}, "abs":[] },
}
const ABILITIES = {
	"counterattack":{},
}

func timeout(val):
	return get_tree().create_timer(val).timeout

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
	await timeout(.2)

func launch_trigger(launcher, def_card):
	# on_apply_dice on_pre_appliy_dice
	for ab in def_card["abs"]:
		if has_method(ab.name+"_"+launcher): 
			Effector.shake(ab.node)
			await call(ab.name+"_"+launcher, ab, def_card)
			await timeout(.5)

func counterattack_on_apply_dice(ab_data, def_card):
	await timeout(.5)
	print("EJECUCCION CONTRATAQUE! ",ab_data.name)

func shield_on_pre_apply_dice(ab_data, def_card):
	var dice = DiceManager.get_dice_drag() 
	if dice.type != "S": return
	await timeout(1)
	for i in range(ab_data.count):
		dice.value -= 1
		ab_data.count -= 1
	def_card.node.update_abs()
	print("EJECUCCION SHIELD! ",ab_data.level)

func shield_on_start_turn(ab_data, def_card):
	ab_data.count = ab_data.max_count
	def_card.node.update_abs()
