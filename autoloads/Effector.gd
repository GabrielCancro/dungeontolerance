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

func float_text(text, pos, style="NORMAL"):
	var ft = preload("res://nodes/FloatTextFx.tscn").instantiate()
	get_node("/root/Game/CLUI").add_child(ft)
	ft.init(text, pos, style)

func fade_down_and_free(node):
	var tw = create_tween()
	tw.tween_property(node,"position:y",node.position.y+25,.25).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(node,"modulate:a",0,.25).set_ease(Tween.EASE_OUT)
	tw.play()
	await tw.finished
	node.queue_free()
