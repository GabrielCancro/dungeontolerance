extends Node

var STATS = {"S":2,"D":1,"M":1}

func _on_click_party_ability(ab_data):
	DiceManager.set_dice_drag(null)
	if has_method("ab_"+ab_data.name):
		print("call ability "+"ab_"+ab_data.name)
		call("ab_"+ab_data.name, ab_data)

func ab_streng(ab_data):
	#CONDITIONS
	if !GameManager.POWERGEM_REF.has_gems("S",1): return false
	GameManager.show_target_chosser("dice",["is_S"])
	var dice = await GameManager.TARGET_CHOSSER_REF.on_chosse
	if !dice: return
	#EFFECT
	Effector.float_text("CHOSSED!",dice.position+dice.size/2+Vector2(0,-20))
	GameManager.POWERGEM_REF.dec_gems("S",1)
	ab_data.node.resalt()
	dice.set_value(dice.value + 1)

func apply_damage(val,def_data):
	Effector.float_text("-"+str(val)+"HP",Vector2(300,420),"DAMAGE")
	var img = get_node("/root/Game/CLBG/ImageParty")
	Effector.damage(img)
	await DefianceManager.launch_trigger("on_end_defiance_attack",def_data)

func roll_party_dices():
	print("ROLLING ",STATS)
	for k in STATS.keys(): 
		for i in range(STATS[k]): 
			DiceManager.add_dice(k)
			await GameManager.timeout(.2)
	await GameManager.timeout(.7)
