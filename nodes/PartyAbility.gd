extends Control

var ab_data = {}

func _ready() -> void:
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.connect("button_down",_on_click)
	$Button.focus_mode = FOCUS_NONE

func set_ability(_name):
	ab_data = PartyManager.get_ability_data(_name)
	ab_data["name"] = _name
	ab_data["node"] = self
	update_reqs()

func _on_hover(val):
	$BGColor.visible = val
	var name = Lang.get_text("ab_"+ab_data.name+"_name",["TITLE"])
	var req = ""
	for k in ab_data["req"].keys(): for i in range(ab_data["req"][k]): req+="[color="+DiceManager.COLORS[k]+"] @ [/color]"
	if val: HintManager.set_text(name+" "+req+"\n"+Lang.get_text("ab_"+ab_data.name))
	else: HintManager.set_text()

func _on_click():
	PartyManager._on_click_party_ability(ab_data)

func update_reqs():
	for n in $HBox.get_children(): n.visible = false
	var index = 0
	for k in ab_data["req"].keys(): for i in range(ab_data["req"][k]):
		$HBox.get_child(index).visible = true
		$HBox.get_child(index).modulate = DiceManager.COLORS[k]
		index += 1

func resalt():
	Effector.boom(self)
