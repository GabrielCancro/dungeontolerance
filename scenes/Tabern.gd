extends Control

var t = {}
var off_color = Color(.6,.6,.6,1)
var selected = [null,null,null]

func _ready() -> void:
	$Continue.connect("button_down",_on_click)
	$ResetData.connect("button_down",_on_click_reset)
	$AddPrestige.connect("button_down",_on_click_add_prestige)
	$ExpText/Label.text = "PRESTIGIO "+str(SaveManager.DATA["prestige"])
	$ExpText/Label.text += "\nEXPEDITION "+str(SaveManager.DATA["expedition"])
	HintManager.init($HintPanel)
	update_selected()
	for c in $Characters.get_children():
		var i = c.get_index()
		t["t"+str(i)] = (0.01+i%4*0.02)
		t["o"+str(i)] = i*0.4
		c.modulate = off_color
		$Buttons.get_child(i).connect("mouse_entered",_on_hover.bind(c,true))
		$Buttons.get_child(i).connect("mouse_exited",_on_hover.bind(c,false))
		$Buttons.get_child(i).connect("button_down",_on_click_character.bind(c))
	for ch in $Party.get_children():
		ch.modulate = off_color
		ch.get_node("Button").connect("mouse_entered",_on_hover.bind(ch,true))
		ch.get_node("Button").connect("mouse_exited",_on_hover.bind(ch,false))
		ch.get_node("Button").connect("button_down",_on_click_character.bind(ch))

func _process(delta: float) -> void:
	for c in $Characters.get_children():
		var i = c.get_index()
		t["t"+str(i)] += delta * (0.02+i%3*0.02)
		c.pivot_offset = c.size * Vector2(.5,.7)
		c.rotation_degrees = sin(t["t"+str(i)]+t["o"+str(i)])*10

func _on_hover(node,val):
	if node in selected: return
	if val: 
		node.modulate = Color(1,1,1,1)
		var pj = PartyManager.CHARACTERS[0]
		var text = pj.name.to_upper() + " <" + Lang.get_text(pj.class) + ">\n\n"
		Lang.set_text_vars(pj.stats)
		text += Lang.get_text("some_stats")+"\n"
		for ab in pj.abs: text += "\n"+Lang.get_text("ab_"+ab+"_name",["TITLE"]) + "\n" + Lang.get_text("ab_"+ab)+"\n"
		HintManager.set_text(text)
	else: 
		node.modulate = off_color
		HintManager.set_text()

func _on_click():
	GameManager.change_scene("Game")

func _on_click_reset():
	SaveManager.clear_data()

func _on_click_add_prestige():
	SaveManager.DATA["prestige"] += 1
	get_tree().reload_current_scene()

func update_selected():
	for c in $Characters.get_children(): 
		if !c in selected: c.modulate = off_color
	for ch in $Party.get_children():
		ch.visible = selected[ch.get_index()]!=null
		if selected[ch.get_index()]: ch.texture = selected[ch.get_index()].texture

func _on_click_character(ch):
	if ch in $Party.get_children():
		selected[ch.get_index()] = null
		update_selected()
		return
		
	if ch in $Characters.get_children() && ch in selected: 
		return
		
	for i in 3:
		if !selected[i]:
			ch.modulate = Color(0,0,0,1)
			selected[i] = ch
			update_selected()
			return
