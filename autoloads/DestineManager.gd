extends Node

var DESTINE_KEYS = ["campfire"]
var DESTINES = {
	"campfire":{}
}

func show_destine():
	GameManager.DESTINE_REF.show_destine("campfire")
	

func in_campfire_chosse_op1():
	await GameManager.timeout(1)
