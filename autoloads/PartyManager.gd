extends Node

var STATS = {"S":2,"D":1,"M":1}
var DATA = {"HP":20,"HPM":20, "SH":0}
var ABILITIES = ["streng"]
var ITEMS = ["old_axe","sword","rope","crossbow","gold_ring","iron_helm"]
var ITEMS_UNLOCKED = ["old_axe","sword","rope","crossbow","gold_ring","iron_helm"]
var PARTY_CHARACTERS = [null,null,null]
var ABILITIES_DATA = { 
	"streng":{"req":{"S":2} },
}

var ITEMS_DATA = { 
	"old_axe":{"ch":1, "chm":1, "req":{"S":2} },
	"sword":{"ch":1, "chm":1, "req":{} },
	"rope":{"ch":1, "chm":1, "req":{} },
	"crossbow":{"ch":1, "chm":1, "req":{} },
	"gold_ring":{"ch":1, "chm":1, "req":{} },
	"iron_helm":{"ch":1, "chm":1, "req":{} },
}

var CHARACTERS = [
	{"name":"Thor","class":"rogue", "stats":[2,0,0],"abs":["streng"]},
	{"name":"Thor","class":"rogue", "stats":[2,0,0],"abs":["streng"]},
	{"name":"Thor","class":"rogue", "stats":[2,0,0],"abs":["streng"]},
	{"name":"Thor","class":"rogue", "stats":[2,0,0],"abs":["streng"]},
	{"name":"Thor","class":"rogue", "stats":[2,0,0],"abs":["streng"]},
	{"name":"Thor","class":"rogue", "stats":[2,0,0],"abs":["streng"]},
	{"name":"Thor","class":"rogue", "stats":[2,0,0],"abs":["streng"]},
]

func _on_click_party_ability(ab_data):
	DiceManager.set_dice_drag(null)
	if has_method("ab_"+ab_data.name):
		print("call ability "+"ab_"+ab_data.name)
		var result = await call("ab_"+ab_data.name, ab_data)
		if result:
			for k in ab_data.req.keys(): GameManager.POWERGEM_REF.dec_gems(k,ab_data.req[k])
			ab_data["node"].dec_charge()

func get_ability_data(code):
	return ABILITIES_DATA[code].duplicate()

func get_item_data(code):
	return ITEMS_DATA[code].duplicate()

func ab_streng(ab_data):
	#CONDITIONS
	GameManager.show_target_chosser("dice",["is_S"])
	var dice = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !dice: return false
	#EFFECT
	Effector.float_text("CHOSSED!",dice.global_position+dice.size/2+Vector2(0,-35))
	ab_data.node.resalt()
	dice.set_value(dice.value + 2)
	return true

func ab_old_axe(ab_data):
	#CONDITIONS
	GameManager.show_target_chosser("dice",["is_S"])
	var dice = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !dice: return false
	#EFFECT
	Effector.float_text("CHOSSED!",dice.global_position+dice.size/2+Vector2(0,-35))
	ab_data.node.resalt()
	dice.set_value(dice.value * 2)
	return true

func apply_damage(val,def_data):
	if DATA.SH>0: 
		Effector.float_text("-"+str(min(DATA.SH,val))+"SH",Vector2(365,420),"SHIELD")
		DATA.SH -= val
		await GameManager.PARTY_REF.update_shield()
		await GameManager.timeout(.2)
		if DATA.SH<0: val = -1*DATA.SH
		else: val = 0
	if val>0:
		DATA.HP = max(0,DATA.HP-val)
		Effector.float_text("-"+str(val)+"HP",Vector2(320,380),"DAMAGE")
		GameManager.PARTY_REF.damage_fx()
		await DefianceManager.launch_trigger("on_end_defiance_attack",def_data)

func apply_heal(val):
	DATA.HP = min(DATA.HPM,DATA.HP+val)
	Effector.float_text("+"+str(val)+"HP",Vector2(320,400),"NORMAL")
	GameManager.PARTY_REF.healt_fx()

func restore_hp():
	DATA.HP = DATA.HPM
	GameManager.PARTY_REF.update_ui()

func add_shield(val):
	DATA.SH += val
	await GameManager.PARTY_REF.update_shield()

func clear_shield():
	DATA.SH = 0
	GameManager.PARTY_REF.update_shield()
	GameManager.timeout(.5)

func roll_party_dices():
	print("ROLLING ",STATS)
	for k in STATS.keys(): 
		for i in range(STATS[k]): 
			DiceManager.add_dice(k)
			await GameManager.timeout(.2)
	await GameManager.timeout(.7)

func update_abilities_ui():
	for pa in GameManager.PARTY_ABILITIES_REF.get_children(): 
		pa.visible = false
	for i in ABILITIES.size():
		GameManager.PARTY_ABILITIES_REF.get_child(i).set_ability(ABILITIES[i])
		GameManager.PARTY_ABILITIES_REF.get_child(i).visible = true

func update_items_ui():
	for pa in GameManager.PARTY_ITEMS_REF.get_children(): 
		pa.visible = false
	for i in ITEMS.size():
		GameManager.PARTY_ITEMS_REF.get_child(i).set_item(ITEMS[i])
		GameManager.PARTY_ITEMS_REF.get_child(i).visible = true

func add_item(code):
	ITEMS.append(code)
	update_items_ui()
	GameManager.PARTY_ITEMS_REF.get_child(ITEMS.size()-1).resalt()

func get_stats_array():
	return [STATS["S"],STATS["D"],STATS["M"]]
