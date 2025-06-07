extends Control

var type = "F"
var value = 0

func _ready() -> void:
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.connect("button_down",DiceManager.set_dice_drag.bind(self))
	$Button.focus_mode = FOCUS_NONE
	randomize()
	set_random_type()
	roll()

func _on_hover(val):
	$BGColor.visible = val
	
func set_random_type():
	var elem = ["F","D","S"]
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
	if DiceManager.get_dice_drag() == self:
		DiceManager.set_dice_drag(null)
	queue_free()
