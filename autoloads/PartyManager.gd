extends Node

var STATS = {"S":2,"D":1,"M":1}
var DATA = {"HP":20,"HPM":20, "SH":0, "SANITY":1}
var ABILITIES = []
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
	"dage":{"chm":1, "req":{} },
	"old_axe":{"chm":1, "req":{"S":1} },
	"sword":{"chm":1, "req":{} },
	"rope":{"chm":1, "req":{} },
	"crossbow":{"chm":1, "req":{"D":1} },
	"gold_ring":{"chm":1, "req":{"M":1} },
	"iron_helm":{"chm":1, "req":{} },
	"bread":{"uses":3, "chm":1, "req":{} },
	"speed_bots":{"chm":1, "req":{} },
}

var CHARACTERS = [
	{"name":"Thior","class":"explorer","lv":0, "hp":8, "sanity":2, "stats":[1,1,0],"abs":null},
	{"name":"Samuel","class":"rogue","lv":4, "hp":6, "sanity":1, "stats":[0,1,1],"abs":null},
	{"name":"Ryna","class":"barbarian","lv":5, "hp":8, "sanity":1, "stats":[2,0,0],"abs":null},
	{"name":"Alem","class":"explorer","lv":0, "hp":8, "sanity":2, "stats":[0,1,0],"abs":"atletic"},
	{"name":"Hanna","class":"sorcerer","lv":0, "hp":5, "sanity":4, "stats":[0,0,1],"abs":"bendition"},
	{"name":"Brian","class":"rogue","lv":0, "hp":6, "sanity":2, "stats":[0,1,0],"abs":"subtlety"},
	{"name":"Drum","class":"warrior","lv":2, "hp":10, "sanity":1, "stats":[1,0,0],"abs":"protector"},
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
	var ab_data = ABILITIES_DATA[code].duplicate()
	ab_data["name"] = code
	if "chm" in ab_data: ab_data["ch"] = ab_data["chm"]
	return ab_data

func get_item_data(code):
	var ab_data = ITEMS_DATA[code].duplicate()
	ab_data["name"] = code
	if "chm" in ab_data: ab_data["ch"] = ab_data["chm"]
	return ab_data

func ab_streng(ab_data):
	#CONDITIONS
	GameManager.show_target_chosser("dice",["is_S"])
	var dice = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !dice: return false
	#EFFECT
	ab_data.node.resalt()
	dice.add_bonif(3)
	return true

func ab_subtlety(ab_data):
	#CONDITIONS
	GameManager.show_target_chosser("dice",["is_D"])
	var dice = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !dice: return false
	#EFFECT
	ab_data.node.resalt()
	dice.add_bonif(3)
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
	elif dice.type == "D": dice.set_type("S")
	dice.add_bonif(2)
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
	dices[0].add_bonif(2)
	return true

#ITEMS
func ab_dage(ab_data):
	#CONDITIONS
	GameManager.show_target_chosser("defiance",["is_creature"])
	var def = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !def: return false
	#EFFECT
	await GameManager.timeout(.2)
	def.damage_defiance(2)
	return true

func ab_crossbow(ab_data):
	#CONDITIONS
	GameManager.show_target_chosser("defiance",["is_creature"])
	var def = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !def: return false
	#EFFECT
	await GameManager.timeout(.2)
	def.damage_defiance(4)
	return true

func ab_old_axe(ab_data):
	#CONDITIONS
	GameManager.show_target_chosser("dice",["is_S"])
	var dice = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !dice: return false
	#EFFECT
	dice.add_bonif(randi_range(1,6))
	return true

func ab_sword(ab_data):
	DiceManager.add_dice("S")
	await GameManager.timeout(.5)
	return true

func ab_gold_ring(ab_data):
	#EFFECT
	await GameManager.timeout(.2)
	_async_ab_gold_ring()
	return true

func _async_ab_gold_ring():
	for i in 3:
		await GameManager.timeout(.5)
		GameManager.POWERGEM_REF.inc_gems("M",1)

func ab_bread(ab_data):
	PartyManager.apply_heal(3)
	await GameManager.timeout(1)
	return true

func ab_speed_bots(ab_data):
	GameManager.timeout(.4)
	DiceManager.add_dice("D")
	return true

func ab_rope(ab_data):
	GameManager.timeout(.4)
	PartyManager.add_shield(2)
	await GameManager.timeout(.5)
	for dice in GameManager.DICES_REF.get_children():
		if dice.type=="D":
			await GameManager.timeout(.5)
			dice.add_bonif(1)
	return true

func ab_iron_helm(ab_data):
	GameManager.timeout(.4)
	PartyManager.add_shield(5)
	return true

#END ITEMS
func apply_damage(val,def_data):
	if DATA.SH>0: 
		Effector.float_text("-"+str(min(DATA.SH,val))+"SH",Vector2(365,420),"SHIELD")
		DATA.SH -= val
		await GameManager.PARTY_REF.update_shield()
		await GameManager.timeout(.2)
		if DATA.SH<0: val = -1*DATA.SH
		else: val = 0
		DATA.SH = max(DATA.SH,0)
	if val>0:
		DATA.HP = max(0,DATA.HP-val)
		Effector.float_text("-"+str(val)+"HP",Vector2(320,380),"DAMAGE")
		GameManager.PARTY_REF.damage_fx()
		await DefianceManager.launch_trigger("on_end_defiance_attack",def_data)
	if DATA.HP<=0:
		GameManager.show_popup("GameOver")

func apply_direct_damage(val,def_data):
	DATA.HP = max(0,DATA.HP-val)
	Effector.float_text("-"+str(val)+"HP",Vector2(320,380),"DAMAGE")
	GameManager.PARTY_REF.damage_fx()
	await DefianceManager.launch_trigger("on_end_defiance_attack",def_data)
	if DATA.HP<=0: GameManager.show_popup("GameOver")

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
			var dice = DiceManager.add_dice(k)
			if GameManager.ROLL_DICE_ON_START_TURN: dice.roll()
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
	print("CALL ADD ITEM: "+code)
	ITEMS_EQUIPPED.append(get_item_data(code))
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

func dec_sanity(val=1):
	if !GameManager.EYE_TRACK_REF.visible: return
	DATA.SANITY = max(0,DATA.SANITY-val)
	Effector.float_text("-"+str(val),Vector2(100,150),"NORMAL")
	GameManager.EYE_TRACK_REF.update_ui()

func add_sanity(val=1):
	if !GameManager.EYE_TRACK_REF.visible: return
	DATA.SANITY = DATA.SANITY+val
	Effector.float_text("+"+str(val),Vector2(100,150),"NORMAL")
	GameManager.EYE_TRACK_REF.update_ui()
