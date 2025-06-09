extends Node

# triggercodes: on_apply_dice
var ALL_DEFIANCES = []
const DEFIANCES = {
	"goblin":{"req":{"S":2,"D":5}, "abs":[{"name":"counterattack","level":2},{"name":"activation","level":2,"count":0}] },
}
const ABILITIES = {
	"counterattack":{},
}

func get_random_defiance():
	randomize()
	var k = DEFIANCES.keys()[randi()%DEFIANCES.keys().size()]
	var data = DEFIANCES[k].duplicate(true)
	for r in DiceManager.COLORS.keys(): data.req[r] = randi()%10
	return data

func launch_on_apply_dice(def_card):
	for ab in def_card["abs"]:
		if has_method("on_apply_dice_"+ab.name): 
			call("on_apply_dice_"+ab.name, ab, def_card)

func on_apply_dice_counterattack(ab_data, def_card):
	print("EJECUCCION CONTRATAQUE! ",ab_data.name)
