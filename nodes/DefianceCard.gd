extends Control

var def_data = {}
signal on_destroy

func _ready() -> void:
	update_ui()
	update_abs()
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.connect("button_down",_on_click)
	$Button.focus_mode = FOCUS_NONE
	DefianceManager.ALL_DEFIANCES.append(def_data)

func set_data(_data):
	def_data = _data
	def_data["node"] = self
	$TextureRect.texture = load("res://assets/defiances/"+def_data.name+".png")
	$Name.text = Lang.get_text("def_"+def_data.name+"_name")
	if "boss" in def_data: 
		pivot_offset = size/2
		scale = Vector2(1.2,1.2)

func _on_hover(val):
	$BGColor.visible = val

func update_abs():
	for ab in $Abilities.get_children(): ab.visible = false
	for i in def_data["abs"].size():
		$Abilities.get_child(i).set_data(def_data["abs"][i])
		$Abilities.get_child(i).visible = true

func update_ui():
	$HP/Value.text = str(def_data.hp)
	for statLine in $Stats.get_children():
		var k = statLine.get_name()
		statLine.text = str(def_data.stats[k])
		if def_data.stats[k]==0: statLine.text = "-"
		statLine.add_theme_color_override("font_color",DiceManager.COLORS[k])

func _on_click():
	var dice = DiceManager.get_dice_drag()
	if !dice: return
	if !dice.is_rolled: await dice.roll()
	if dice.type in def_data.stats.keys(): 
		await Effector.boom_big($Stats.get_node(dice.type))
		if dice.is_rolled:
			if dice.value-def_data.stats[dice.type]<=0: return
		var damage = max(0,dice.value-def_data.stats[dice.type])
		await GameManager.timeout(.5)
		dice.set_value(damage)
		await GameManager.timeout(.7)
	await DefianceManager.launch_trigger("on_pre_apply_dice", def_data)
	dice.consume_dice()
	await damage_defiance(dice.value)
	if !is_dead(): await DefianceManager.launch_trigger("on_apply_dice", def_data)

func dec_stats(type,val):
	def_data.stats[type] -= val
	Effector.damage(self)
	Effector.float_text("-"+str(val),position+Vector2(50,-10),DiceManager.COLORS[type])
	update_ui()

func add_stats(type,val):
	if !type in def_data.stats: def_data.stats[type] = 0
	def_data.stats[type] += val
	Effector.float_text("+"+str(val),position+Vector2(50,-10),DiceManager.COLORS[type])
	update_ui()

func heal_defiance(val):
	def_data.hp += val
	Effector.boom_big($HP)
	Effector.float_text("+"+str(val)+"HP",position+Vector2(50,-10),"ff0000")
	update_ui()

func damage_defiance(dam):
	if dam<=0: return
	def_data.hp -= dam
	if def_data.hp<=0: $HP.modulate = Color(1,0,0,1)
	else: $HP.modulate = Color(1,1,1,1)
	update_ui()
	GameManager.timeout(.5)
	Effector.float_text("-"+str(dam),position+Vector2(50,-10),"ff0000")
	Effector.boom_big($HP)
	await Effector.damage(self)
	if is_dead(): await dead()
	return true

func is_dead(): 
	if (def_data.hp <= 0): return true
	else: return false

func dead():
	$Light.modulate = Color(1,0,0)
	await DefianceManager.launch_trigger("on_dead_defiance", def_data)
	DefianceManager.ALL_DEFIANCES.erase(def_data)
	#PartyManager.add_sanity(1)
	print("DefianceManager.ALL_DEFIANCES ",DefianceManager.ALL_DEFIANCES)
	await GameManager.timeout(.5)
	emit_signal("on_destroy")
	await Effector.fade_down(self)
	await LevelManager.reorder_cards()
	queue_free()

func discard():
	DefianceManager.ALL_DEFIANCES.erase(def_data)
	await Effector.fade_down(self)
	await LevelManager.reorder_cards()
	queue_free()

func ligth(val):
	$Light.visible = val
	if val: Effector.appear_defiance_shadow(self)
	else: Effector.hide_defiance_shadow()
