extends Node

# triggercodes: on_apply_dice
var ALL_DEFIANCES = []
const DEFIANCES = {
	"goblin":{"req":{"S":2,"D":5}, "abs":["counterattack"]},
}

const ABILITIES = {
	"counterattack":{"trigger": "on_apply_dice"},
}

func get_random_defiance():
	randomize()
	var k = DEFIANCES.keys()[randi()%DEFIANCES.keys().size()]
	var data = DEFIANCES[k].duplicate(true)
	for r in DiceManager.COLORS.keys(): data.req[r] = randi()%10
	return data

func launch_on_apply_dice(def_card):
	for ab in def_card["abs"]:
		if has_method("on_apply_dice_"+ab): 
			call("on_apply_dice_"+ab,def_card)

func on_apply_dice_counterattack(def_card):
	print("EJECUCCION CONTRATAQUE! ",def_card)
