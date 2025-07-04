extends Control

var is_tabern = false
var ab_data = {}
signal on_click_tabern_item(item)

func _ready() -> void:
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.connect("button_down",_on_click)
	$Button.focus_mode = FOCUS_NONE

func set_ability(_name):
	ab_data = PartyManager.get_ability_data(_name)
	ab_data["name"] = _name
	ab_data["is_item"] = false
	ab_data["node"] = self
	$TextureRect.texture = load("res://assets/abilities/ab_"+_name+".png")
	update_reqs()

func set_item(_name):
	ab_data = PartyManager.get_item_data(_name)
	ab_data["name"] = _name
	ab_data["is_item"] = true
	ab_data["node"] = self
	$TextureRect.texture = load("res://assets/abilities/ab_"+_name+".png")
	update_reqs()

func _on_hover(val):
	$BGColor.visible = val
	var name = Lang.get_text("ab_"+ab_data.name+"_name",["TITLE"])
	var req = ""
	for k in ab_data["req"].keys(): for i in range(ab_data["req"][k]): req+="[color="+DiceManager.COLORS[k]+"] @ [/color]"
	if val: HintManager.set_text(name+" "+req+"\n"+Lang.get_text("ab_"+ab_data.name))
	else: HintManager.set_text()

func _on_click():
	if is_tabern: 
		emit_signal("on_click_tabern_item",self)
		return
	#CHECK CHARGE
	if "ch" in ab_data and ab_data["ch"]<=0: 
		Effector.shake(get_node("TextureRect"))
		return
	#CHECK REQUISITES
	for k in ab_data.req.keys():
		if !GameManager.POWERGEM_REF.has_gems(k,ab_data.req[k]): return false
	#ITS OK!
	PartyManager._on_click_party_ability(ab_data)

func update_reqs():
	for n in $HBox.get_children(): n.visible = false
	var index = 0
	for k in ab_data["req"].keys(): for i in range(ab_data["req"][k]):
		$HBox.get_child(index).visible = true
		$HBox.get_child(index).get_node("color").modulate = DiceManager.COLORS[k]
		index += 1
		print("UPDATE!!!!! ", ab_data)

func dec_charge():
	if !"ch" in ab_data: return
	ab_data["ch"] = max(0, ab_data["ch"]-1)
	if ab_data["ch"]<=0: modulate = Color(.5,.5,.5,.7)
	else:  modulate = Color(1,1,1,1)

func restore_charges():
	if !"ch" in ab_data: return
	ab_data["ch"] = ab_data["chm"]
	modulate = Color(1,1,1,1)

func resalt():
	Effector.boom(self)

func set_selected(val):
	$BorderSelected.visible = val
