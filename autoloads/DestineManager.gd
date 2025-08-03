extends Node

var DESTINE_KEYS = ["campfire"]
var DESTINES = {
	"campfire":{}
}

func show_destine():
	GameManager.DESTINE_REF.show_destine("campfire")

func on_chosse(destine,op):
	print("CHOSSE "+destine+" op"+str(op))
	if has_method("in_"+destine+"_chosse_op"+str(op)):
		await call("in_"+destine+"_chosse_op"+str(op))
	await GameManager.timeout(1)
	GameManager.on_end_turn()

func in_campfire_chosse_op1():
	#DEC EYES
	PartyManager.add_sanity(5)
	await GameManager.timeout(.5)

func in_campfire_chosse_op2():
	#ADD +5HP
	PartyManager.apply_heal(7)
	await GameManager.timeout(.5)

func in_campfire_chosse_op3():
	#ADD BREAD
	PartyManager.add_item("bread")
	await GameManager.timeout(.5)
