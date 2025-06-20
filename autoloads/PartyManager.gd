extends Node

var STATS = {"S":2,"D":1,"M":1}
var DATA = {"HP":20,"HPM":20, "SH":0}
var ABILITIES = ["streng"]

var ABILITIES_DATA = { 
	"streng":{"req":{"S":2} },
}

func _on_click_party_ability(ab_data):
	DiceManager.set_dice_drag(null)
	if has_method("ab_"+ab_data.name):
		print("call ability "+"ab_"+ab_data.name)
		call("ab_"+ab_data.name, ab_data)

func get_ability_data(code):
	return ABILITIES_DATA[code].duplicate()

func ab_streng(ab_data):
	#CONDITIONS
	for k in ab_data.req.keys():
		if !GameManager.POWERGEM_REF.has_gems(k,ab_data.req[k]): return false
	GameManager.show_target_chosser("dice",["is_S"])
	var dice = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !dice: return
	#EFFECT
	Effector.float_text("CHOSSED!",dice.global_position+dice.size/2+Vector2(0,-35))
	for k in ab_data.req.keys(): GameManager.POWERGEM_REF.dec_gems(k,ab_data.req[k])
	ab_data.node.resalt()
	dice.set_value(dice.value + 2)

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
	if DATA.SH>0: 
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
