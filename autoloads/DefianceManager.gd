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

func launch_on_apply_dice(def_card):
	for ab in def_card["abs"]:
		if has_method("on_apply_dice_"+ab.name): 
			call("on_apply_dice_"+ab.name, ab, def_card)

func on_apply_dice_counterattack(ab_data, def_card):
	print("EJECUCCION CONTRATAQUE! ",ab_data.name)
