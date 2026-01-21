extends Control

var is_tabern = false
var ab_data = {}
signal on_click_tabern_item(item)

func _ready() -> void:
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.connect("button_down",_on_click)
	$Button.focus_mode = FOCUS_NONE

func set_ability(_ab_data):
	ab_data = _ab_data
	ab_data["is_item"] = false
	ab_data["node"] = self
	$lb_uses.visible = false
	$TextureRect.texture = load("res://assets/abilities/ab_"+ab_data["name"]+".png")
	update_reqs()

func set_item(_ab_data):
	ab_data = _ab_data
	ab_data["is_item"] = true
	ab_data["node"] = self
	$TextureRect.texture = load("res://assets/abilities/ab_"+ab_data["name"]+".png")
	update_reqs()
	$lb_uses.visible = ("uses" in ab_data)
	if ("uses" in ab_data): $lb_uses.text = "x"+str(ab_data["uses"])

func _on_hover(val):
	$BGColor.visible = val
	var text = Lang.get_text("ab_"+ab_data.name+"_name",["TITLE"])
	if "uses" in ab_data: text += "\n[color=A0A0A0]("+Lang.get_text("ui_uses")+" x"+str(ab_data["uses"])+" )[/color]"
	if have_any_req(): text += "\n[color=A0A0A0]( "+Lang.get_text("ui_req")+"  "+Lang.get_req_string(ab_data["req"])+"  )[/color]"
	text += "\n"+Lang.get_text("ab_"+ab_data.name)
	if val: HintManager.set_text(text)
	else: HintManager.set_text()

func _on_click():
	if is_tabern: 
		emit_signal("on_click_tabern_item",self)
		Sounds.play_sound("fail")
		return
	#CHECK CHARGE
	if "ch" in ab_data and ab_data["ch"]<=0: 
		Effector.shake(get_node("TextureRect"))
		Sounds.play_sound("fail")
		return
	#CHECK REQUISITES
	for k in ab_data.req.keys():
		if !GameManager.POWERGEM_REF.has_gems(k,ab_data.req[k]): 
			Sounds.play_sound("fail")
			return false
	#ITS OK!
	Sounds.play_sound("item_select")
	PartyManager._on_click_party_ability(ab_data)

func update_reqs():
	for n in $HBox.get_children(): n.visible = false
	var index = 0
	for k in ab_data["req"].keys(): for i in range(ab_data["req"][k]):
		$HBox.get_child(index).visible = true
		$HBox.get_child(index).get_node("color").modulate = DiceManager.COLORS[k]
		index += 1

func dec_charge():
	if "ch" in ab_data:
		ab_data["ch"] = max(0, ab_data["ch"]-1)
		if ab_data["ch"]<=0: modulate = Color(.5,.5,.5,.7)
		else:  modulate = Color(1,1,1,1)
	if "uses" in ab_data:
		ab_data["uses"] = max(0, ab_data["uses"]-1)
		if ab_data["uses"]<=0: 
			PartyManager.ITEMS_EQUIPPED.remove_at(get_index())
		PartyManager.update_items_ui()

func restore_charges():
	if !"ch" in ab_data: return
	ab_data["ch"] = ab_data["chm"]
	modulate = Color(1,1,1,1)

func resalt():
	Effector.boom(self)

func set_selected(val):
	$BorderSelected.visible = val

func have_any_req():
	for k in ab_data["req"]:
		if ab_data["req"][k]>0: return true
	return false
