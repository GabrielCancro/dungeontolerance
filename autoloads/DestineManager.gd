extends Node

var DESTINE_KEYS = ["campfire"]
var DESTINES = {
	"campfire":{}
}

func show_destine():
	GameManager.DESTINE_REF.show_destine("campfire")

func on_chosse(destine,op):
	print("CHOSSE "+destine+" op"+str(op))
	await GameManager.timeout(1)
	GameManager.on_end_turn()

func in_campfire_chosse_op1():
	await GameManager.timeout(1)
