extends Node

var STATS = {"S":2,"D":1,"M":1}
var DATA = {"HP":20,"HPM":20, "SH":0}
var ABILITIES = ["streng"]
var ITEMS_EQUIPPED = []
var ITEMS_UNLOCKED = []
var PARTY_CHARACTERS = [null,null,null]
var ABILITIES_DATA = { 
	"streng":{"req":{"S":2} },
	"subtlety":{"req":{"D":2} },
	"atletic":{"req":{"S":1,"D":1} },
	"protector":{"req":{"S":2} },
	"bendition":{"req":{"M":1} },
}

var ITEMS_DATA = { 
	"dage":{"ch":1, "chm":1, "req":{} },
	"old_axe":{"ch":1, "chm":1, "req":{"S":2} },
	"sword":{"ch":1, "chm":1, "req":{} },
	"rope":{"ch":1, "chm":1, "req":{} },
	"crossbow":{"ch":1, "chm":1, "req":{} },
	"gold_ring":{"ch":1, "chm":1, "req":{} },
	"iron_helm":{"ch":1, "chm":1, "req":{} },
}

var CHARACTERS = [
	{"name":"Thior","class":"explorer", "stats":[1,1,0],"abs":null},
	{"name":"Samuel","class":"rogue", "stats":[0,1,1],"abs":null},
	{"name":"Ryna","class":"barbarian", "stats":[2,0,0],"abs":null},
	{"name":"Alem","class":"explorer", "stats":[0,1,0],"abs":"atletic"},
	{"name":"Hanna","class":"sorcerer", "stats":[0,0,1],"abs":"bendition"},
	{"name":"Brian","class":"rogue", "stats":[0,1,0],"abs":"subtlety"},
	{"name":"Drum","class":"warrior", "stats":[1,0,0],"abs":"protector"},
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
	Effector.float_text("+2",dice.global_position+dice.size/2+Vector2(0,-35),dice.get_color())
	ab_data.node.resalt()
	dice.set_value(dice.value + 2)
	return true

func ab_subtlety(ab_data):
	#CONDITIONS
	GameManager.show_target_chosser("dice",["is_D"])
	var dice = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !dice: return false
	#EFFECT
	Effector.float_text("+2",dice.global_position+dice.size/2+Vector2(0,-35),dice.get_color())
	ab_data.node.resalt()
	dice.set_value(dice.value + 2)
	return true

func ab_atletic(ab_data):
	#CONDITIONS
	GameManager.show_target_chosser("dice",["is_S","is_D"])
	var dice = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !dice: return false
	if dice.type == "M": return false
	#EFFECT
	ab_data.node.resalt()
	if dice.type == "S": dice.set_type("D")
	if dice.type == "D": dice.set_type("S")
	Effector.float_text("+2",dice.global_position+dice.size/2+Vector2(0,-35),dice.get_color())
	dice.set_value(dice.value + 2)
	return true

func ab_protector(ab_data):
	#CONDITIONS
	
	#EFFECT
	ab_data.node.resalt()
	PartyManager.add_shield(3)
	return true

func ab_bendition(ab_data):
	#CONDITIONS
	var impars = []
	var dices = GameManager.DICES_REF.get_children()
	if dices.size()<2: return false
	#EFFECT
	ab_data.node.resalt()
	dices.shuffle()
	await GameManager.timeout(.5)
	dices[0].set_value(dices[0].value +1)
	Effector.float_text("+1",dices[0].global_position+dices[0].size/2+Vector2(0,-35),dices[0].get_color())
	return true

#ITEMS
func ab_dage(ab_data):
	#CONDITIONS
	GameManager.show_target_chosser("defiance",[])
	var def = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !def: return false
	#EFFECT
	await GameManager.timeout(.2)
	def.damage_defiance(1)
	return true
	
func ab_old_axe(ab_data):
	#CONDITIONS
	GameManager.show_target_chosser("dice",["is_S"])
	var dice = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !dice: return false
	#EFFECT
	Effector.float_text("+"+str(dice.value),dice.global_position+dice.size/2+Vector2(0,-35),dice.get_color())
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
	for i in ITEMS_EQUIPPED.size():
		GameManager.PARTY_ITEMS_REF.get_child(i).set_item(ITEMS_EQUIPPED[i])
		GameManager.PARTY_ITEMS_REF.get_child(i).visible = true

func add_item(code):
	ITEMS_EQUIPPED.append(code)
	update_items_ui()
	GameManager.PARTY_ITEMS_REF.get_child(ITEMS_EQUIPPED.size()-1).resalt()
	if not code in ITEMS_UNLOCKED: ITEMS_UNLOCKED.append(code)
	SaveManager.DATA["items_unlocked"] = ITEMS_UNLOCKED
	SaveManager.save_store_data()

func get_stats_array():
	return [STATS["S"],STATS["D"],STATS["M"]]

func get_rnd_item():
	#first locked items
	var array = []
	for k in ITEMS_DATA.keys():
		if !k in ITEMS_UNLOCKED: array.append(k)
	if array.size()==0: array = ITEMS_DATA.keys()
	randomize()
	array.shuffle()
	return array[0]
