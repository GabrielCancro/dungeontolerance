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

func boom(node):
	var end_scale = node.scale
	node.pivot_offset = node.size / 2
	node.scale *= 1.2
	var tw = create_tween()
	tw.tween_property(node,"scale",end_scale,.3).set_ease(Tween.EASE_OUT)
	tw.play()

func boom_big(node):
	var end_scale = node.scale
	node.pivot_offset = node.size / 2
	node.scale *= 1.5
	var tw = create_tween()
	tw.tween_property(node,"scale",end_scale,.7).set_ease(Tween.EASE_IN)
	tw.play()

func damage(node):
	randomize()
	var opos = node.position
	var ocolor = node.modulate
	node.modulate = Color(1,.3,.3)
	for i in range(10):
		node.position.x = opos.x + randf_range(-5,5)
		await get_tree().create_timer(.04).timeout
	node.position.x = opos.x
	node.modulate = ocolor

func appear_less(node):
	node.modulate.a = .5
	var tw = create_tween()
	tw.tween_property(node,"modulate:a",1,.4).set_ease(Tween.EASE_OUT)
	tw.play()

func move_to(node,pos):
	var tw = create_tween()
	tw.tween_property(node,"position",pos,.5).set_ease(Tween.EASE_OUT)
	tw.play()
