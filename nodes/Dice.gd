extends Control

var type = "-"
var value = 0
var bonif = 0
var is_rolled = false

func _ready() -> void:
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.connect("button_down",DiceManager.set_dice_drag.bind(self))
	$Button.focus_mode = FOCUS_NONE
	if type=="-": set_random_type()
	update()

func _process(delta: float) -> void:
	for d in GameManager.DICES_REF.get_children():
		if d == self: continue
		if d == DiceManager.get_dice_drag(): continue
		if position.distance_to(d.position)<size.x:
			position -= position.direction_to(d.position)

func _on_hover(val):
	$Shadow.visible = val
	
func set_random_type():
	var elem = DiceManager.COLORS.keys()
	elem.shuffle()
	type = elem[0]
	update()

func roll():
	is_rolled = true
	for i in range(10):
		value = randi()%6+1
		rotation_degrees = randf()*360
		update()
		await GameManager.timeout(.1)
	rotation = 0
	await GameManager.timeout(.7)
	if bonif!=0: _apply_bonif_value()

func update():
	$DiceImage.modulate = DiceManager.COLORS[type]
	if is_rolled: 
		dark_image()
		$Value.text = str(value)
		$Bonif.text = ""
	else:
		$Value.text = ""
		if bonif>0: $Bonif.text = "+"+str(bonif)
		elif bonif==0: $Bonif.text = ""
		elif bonif<0: $Bonif.text = str(bonif)
	$Value.add_theme_color_override("font_color",DiceManager.COLORS[type])

func dark_image():
	$DiceImage.modulate.r *= 0.6
	$DiceImage.modulate.g *= 0.6
	$DiceImage.modulate.b *= 0.6

func consume_dice():
	await Effector.fade_down_and_free(self)
	if DiceManager.get_dice_drag() == self:
		DiceManager.set_dice_drag(null)

func set_value(val):
	value = val
	Effector.boom(self)
	update()

func add_bonif(val):
	bonif += val
	if !is_rolled:
		Effector.boom(self)
		update()
	else: 
		_apply_bonif_value()

func _apply_bonif_value():
	Effector.float_text("+"+str(bonif),global_position+Vector2(30,-10),get_color())
	await GameManager.timeout(.3)
	value += bonif
	update()
	Effector.boom(self)
	await GameManager.timeout(.7)

func set_type(val):
	type = val
	update()

func get_color():
	return DiceManager.COLORS[type]
