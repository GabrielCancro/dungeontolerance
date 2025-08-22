extends Node

var DESTINE_KEYS = ["campfire","old_chest","end_level","fail_level"]
var end_game

func show_destine(destine_code):
	print("SHOW DESTINE ",destine_code)
	end_game = false
	GameManager.DESTINE_REF.show_destine(destine_code)

func on_chosse(destine,op):
	print("CHOSSE "+destine+" op"+str(op))
	await call("on_chosse_"+destine,op)
	if !end_game:
		await GameManager.timeout(.5)
		GameManager.on_end_turn()

func on_chosse_campfire(op):
	if op==1:
		#DEC EYES
		PartyManager.add_sanity(3)
	elif op==2:
		#ADD +5HP
		PartyManager.apply_heal(7)
	elif op==3:
		#ADD BREAD
		PartyManager.add_item("bread")

func on_chosse_old_chest(op):
	if op==1:
		pass
	elif op==2:
		#ADD +5HP
		PartyManager.dec_sanity(3)
		await GameManager.timeout(.5)
		var key = PartyManager.get_rnd_item()
		var texture = load("res://assets/abilities/ab_"+key+".png")
		await Effector.texture_from_to(texture,Vector2(600,300),Vector2(25,5),Vector2(1.2,1.2),Vector2(.5,.5))
		PartyManager.add_item(key)

func on_chosse_end_level(op):
	if op==1:
		end_game = true
		await GameManager.timeout(.5)
		GameManager.change_scene("Tabern")

func on_chosse_fail_level(op):
	if op==1:
		end_game = true
		await GameManager.timeout(.5)
		GameManager.change_scene("Tabern")
