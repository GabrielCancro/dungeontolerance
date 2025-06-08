extends Control

var ab_name

func _ready() -> void:
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	#$Button.connect("button_down",PartyManager._on_click_party_ability.bind("streng"))
	$Button.focus_mode = FOCUS_NONE

func _on_hover(val):
	$BGColor.visible = val
	$BGColor2.visible = val
	if val: HintManager.set_text(Lang.get_text("def_ab_"+ab_name))
	else: HintManager.set_text()

func set_data(data):
	ab_name = data
	$Value.text = Lang.get_text("def_ab_"+ab_name+"_name")
