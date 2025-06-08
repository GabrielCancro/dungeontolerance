extends Control

var req = {}

func _ready() -> void:
	randomize()
	for k in DiceManager.COLORS.keys(): req[k] = randi()%10
	update_ui()
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.connect("button_down",_on_click)
	$Button.focus_mode = FOCUS_NONE

func _on_hover(val):
	$BGColor.visible = val

func update_ui():
	for i in DiceManager.COLORS.keys().size():
		var k = DiceManager.COLORS.keys()[i]
		var ReqLine = get_node("Requisites").get_child(i)
		ReqLine.visible = (k in req.keys()) && req[k]>0
		if ReqLine.visible:
			ReqLine.get_node("Value").text = str(req[k])
			ReqLine.get_node("Value").add_theme_color_override("font_color",DiceManager.COLORS[k])

func _on_click():
	var dice = DiceManager.get_dice_drag()
	if !dice: return
	var k = dice.type
	if dice && k in req.keys() && req[k]>0: 
		req[dice.type] = max(0,req[dice.type]-dice.value)
		update_ui() 
		dice.consume_dice()
		check_dead()

func check_dead():
	for k in req.keys():
		if req[k]>0: return false
	queue_free()
	return true
