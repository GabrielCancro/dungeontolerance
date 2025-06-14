extends Control

var ab_data = {"name":"streng"}

func _ready() -> void:
	ab_data["node"] = self
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.connect("button_down",PartyManager._on_click_party_ability.bind(ab_data))
	$Button.focus_mode = FOCUS_NONE

func _on_hover(val):
	$BGColor.visible = val
	if val: HintManager.set_text(Lang.get_text("ab_streng"))
	else: HintManager.set_text()

func resalt():
	Effector.boom(self)
