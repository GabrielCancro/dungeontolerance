extends Control

var type = "-"
var value = 0

func _ready() -> void:
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.connect("button_down",DiceManager.set_dice_drag.bind(self))
	$Button.focus_mode = FOCUS_NONE
	if type=="-": set_random_type()
	roll()
	print(position)

func _process(delta: float) -> void:
	for d in GameManager.DICES_REF.get_children():
		if d == self: continue
		if d == DiceManager.get_dice_drag(): continue
		if position.distance_to(d.position)<size.x:
			position -= position.direction_to(d.position)

func _on_hover(val):
	$BGColor.visible = val
	
func set_random_type():
	var elem = DiceManager.COLORS.keys()
	elem.shuffle()
	type = elem[0]
	update()

func roll():
	for i in range(10):
		value = randi()%6+1
		rotation_degrees = randf()*360
		await get_tree().create_timer(.1).timeout
		update()
	rotation = 0

func update():
	$Border/cr1.color = DiceManager.COLORS[type]
	$Border/cr2.color = DiceManager.COLORS[type]
	$Border/cr3.color = DiceManager.COLORS[type]
	$Border/cr4.color = DiceManager.COLORS[type]
	$Value.add_theme_color_override("font_color",DiceManager.COLORS[type])
	$Value.text = str(value)

func consume_dice():
	await Effector.fade_down_and_free(self)
	if DiceManager.get_dice_drag() == self:
		DiceManager.set_dice_drag(null)

func set_value(val):
	value = val
	Effector.boom(self)
	update()

func set_type(val):
	type = val
	update()
