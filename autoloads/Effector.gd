extends Node

func shake(node):
	randomize()
	var opos = node.position
	var ocolor = node.modulate
	node.modulate = Color(1,1,.5)
	GameManager.timeout(.7)
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
	tw.tween_property(node,"modulate:a",1,.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.play()

func move_to(node,pos):
	var tw = create_tween()
	tw.tween_property(node,"position",pos,.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.play()

func fade_down(node):
	var start_pos = node.position
	var tw = create_tween()
	tw.tween_property(node,"position:y",node.position.y+25,.3).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(node,"modulate:a",0,.3).set_ease(Tween.EASE_OUT)
	tw.play()
	await tw.finished
	node.position = start_pos

func fade_up(node):
	var end_pos = node.position
	node.position.y += 25
	var tw = create_tween()
	tw.tween_property(node,"position:y",end_pos.y,.3).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(node,"modulate:a",1,.3).set_ease(Tween.EASE_OUT)
	tw.play()
	await tw.finished

func transition_level_off():
	var node = GameManager.BG_IMAGE_REF
	var tw = create_tween()
	tw.tween_property(node,"position",node.position+Vector2(-100,50),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tw.parallel().tween_property(node,"modulate:a",0,1).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(GameManager.DICES_REF,"modulate:a",0,1).set_ease(Tween.EASE_OUT)
	tw.play()
	await GameManager.timeout(1.5)

func transition_level_on():
	var node = GameManager.BG_IMAGE_REF
	node.position = Vector2(100,-50)
	var tw = create_tween()
	tw.tween_property(node,"position",node.position+Vector2(-100,50),1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tw.parallel().tween_property(node,"modulate:a",1,1).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(GameManager.DICES_REF,"modulate:a",1,1).set_ease(Tween.EASE_OUT)
	tw.play()
	await GameManager.timeout(1.5)

func appear_destine(node):
	var to = node.position
	node.modulate.a = 0
	node.position += Vector2(+50,-25)
	var tw = create_tween()
	tw.tween_property(node,"position",to,.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tw.parallel().tween_property(node,"modulate:a",1,.5).set_ease(Tween.EASE_OUT)
	tw.play()
	await GameManager.timeout(.7)

func texture_from_to(_texture,_start_pos,_end_pos,_start_scale,_end_scale):
	var node = TextureRect.new()
	node.texture = _texture
	node.pivot_offset = node.size/2
	node.position = _start_pos-node.size/2
	node.scale = _start_scale*0.7
	node.modulate.a = 0
	GameManager.GAME_SCENE_REF.add_child(node)
	var tw = create_tween()
	tw.tween_property(node,"scale",_start_scale,.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tw.parallel().tween_property(node,"modulate:a",1,1).set_ease(Tween.EASE_OUT)
	tw.play()
	await tw.finished
	tw = create_tween()
	tw.tween_property(node,"position",_end_pos,.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tw.parallel().tween_property(node,"scale",_end_scale,.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tw.parallel().tween_property(node,"modulate:a",0,1).set_ease(Tween.EASE_OUT)
	tw.play()
	await tw.finished
	node.queue_free() 

func appear_defiance_shadow(node):
	var dices = get_node("/root/Game/Dices")
	var shadow = get_node("/root/Game/DefShadow")
	shadow.position = node.position + node.size/2 - shadow.size/2 + Vector2(0,30)
	shadow.visible = true
	var tw = create_tween()
	tw.tween_property(shadow,"modulate:a",.7,.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tw.parallel().tween_property(dices,"modulate:a",0,.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tw.play()

func hide_defiance_shadow():
	var dices = get_node("/root/Game/Dices")
	var shadow = get_node("/root/Game/DefShadow")
	var tw = create_tween()
	tw.tween_property(shadow,"modulate:a",0,.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tw.parallel().tween_property(dices,"modulate:a",1,.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tw.play()
	await tw.finished
	shadow.visible = false

#func sanity_fx():
	#var ref = get_node("/root/Game/CLUI/SanityFx")
	#var tw = create_tween()
	#for t in ref.get_children():
		#if t.get_index()==0: continue
		#t.modulate.a = 0
		#t.rotation -= randf_range(0,1)
		##tw.parallel().tween_property(t,"modulate:a",1,randf_range(.4,.8)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		##tw.parallel().tween_property(t,"rotation",t.rotation+randf_range(.1,.2),2)
		##tw.parallel().tween_property(t,"modulate:a",0,randf_range(.4,.8)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_delay(1)
	#tw.play()
	#ref.visible = true
	#await tw.finished
	#ref.visible = false
