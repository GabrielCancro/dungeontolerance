extends Control

var ab_data

func _ready() -> void:
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	#$Button.connect("button_down",PartyManager._on_click_party_ability.bind("streng"))
	$Button.focus_mode = FOCUS_NONE

func _on_hover(val):
	$BGColor.visible = val
	$BGColor2.visible = val
	Lang.set_text_vars([ab_data.level])
	if ab_data.name == "activation":
		Lang.set_text_vars([ab_data.count,ab_data.level])
	if val: HintManager.set_text(Lang.get_text("def_ab_"+ab_data.name))
	else: HintManager.set_text()

func set_data(data):
	ab_data = data
	$Value.text = Lang.get_text("def_ab_"+ab_data.name+"_name")+" "+str(ab_data.level)
	if ab_data.name == "activation":
		$Value.text = Lang.get_text("def_ab_"+ab_data.name+"_name")+" "+str(ab_data.count)+"/"+str(ab_data.level)
