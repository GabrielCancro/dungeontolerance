extends Node

func _on_click_party_ability(ab_name):
	if has_method("ab_"+ab_name):
		print("call ability "+"ab_"+ab_name)
		call("ab_"+ab_name)

func ab_streng():
	var dice = DiceManager.get_dice_drag()
	print("dice",dice)
	if !dice: return
	print("TYPE"+dice.type)
	if dice.type != "S": return
	print("ab_streng TRUE")
	dice.set_value(dice.value + 1)

func apply_damage(val):
	Effector.float_text("-"+str(val)+"HP",Vector2(300,420),"DAMAGE")
	var img = get_node("/root/Game/CLBG/ImageParty")
	Effector.shake(img)
