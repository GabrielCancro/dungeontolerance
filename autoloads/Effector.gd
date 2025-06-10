extends Node

func shake(node):
	randomize()
	var opos = node.position
	var ocolor = node.modulate
	node.modulate = Color(1,1,.5)
	for i in range(10):
		node.position.x = opos.x + randf_range(-5,5)
		await get_tree().create_timer(.05).timeout
	node.position.x = opos.x
	node.modulate = ocolor
