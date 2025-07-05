extends Control

var t = {}
var off_color = Color(.7,.7,.7,1)
var selected = [null,null,null]
var selected_items = []

func _ready() -> void:
	#SaveManager.DATA["prestige"]=1
	$Continue.connect("button_down",_on_click_continue)
	$ResetData.connect("button_down",_on_click_reset)
	$AddPrestige.connect("button_down",_on_click_add_prestige)
	$ExpText/Label.text = "PRESTIGIO "+str(SaveManager.DATA["prestige"])
	$PR/Label.text = str(floor(SaveManager.DATA["prestige"]))
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
		$PartyButtons.get_child(ch.get_index()).connect("mouse_entered",_on_hover.bind(ch,true))
		$PartyButtons.get_child(ch.get_index()).connect("mouse_exited",_on_hover.bind(ch,false))
		$PartyButtons.get_child(ch.get_index()).connect("button_down",_on_click_character.bind(ch))
	
	update_items_ui()
	for it in $Items.get_children(): 
		it.connect("on_click_tabern_item",_on_item_click)
	
	if SaveManager.DATA["prestige"]==1:
		await $Tutorial.show_tuto("tabern1")
		await $Tutorial.show_tuto("tabern2")
		await $Tutorial.show_tuto("tabern3")
		await $Tutorial.show_tuto("tabern4")
		await $Tutorial.show_tuto("tabern5")
		await $Tutorial.show_tuto("tabern6")
		await $Tutorial.show_tuto("tabern7")

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

func _on_click_continue():
	PartyManager.ITEMS.clear()
	for it in selected_items: PartyManager.ITEMS.append(it.ab_data.name)
	PartyManager.PARTY_CHARACTERS.clear()
	for ch in selected: 
		print(ch.get_name())
		PartyManager.PARTY_CHARACTERS.append(int(str(ch.get_name())[-1]))
	GameManager.change_scene("Game")

func _on_click_reset():
	SaveManager.clear_data()

func _on_click_add_prestige():
	SaveManager.DATA["prestige"] += 1
	get_tree().reload_current_scene()

func update_selected():
	for c in $Characters.get_children(): 
		if !c in selected: c.modulate = off_color
		$Continue.disabled = false
		$Continue.modulate.a = 1
	for ch in $Party.get_children():
		$PartyButtons.get_child(ch.get_index()).visible = (selected[ch.get_index()]!=null)
		if selected[ch.get_index()]: 
			ch.texture = selected[ch.get_index()].texture
		else: 
			ch.texture = load("res://assets/characters/siluet.png")
			$Continue.disabled = true
			$Continue.modulate.a = .6
	PartyManager.STATS["S"]=0
	PartyManager.STATS["D"]=0
	PartyManager.STATS["M"]=0
	for ch in $Party.get_children():
		if selected[ch.get_index()]: 
			var index = int(str(selected[ch.get_index()])[-1])
			PartyManager.STATS["S"]+=PartyManager.CHARACTERS[index]["stats"][0]
			PartyManager.STATS["D"]+=PartyManager.CHARACTERS[index]["stats"][1]
			PartyManager.STATS["M"]+=PartyManager.CHARACTERS[index]["stats"][2]
	Lang.set_text_vars(PartyManager.get_stats_array())
	$Stats/RichTextLabel.text = Lang.get_text("some_stats")

func _on_click_character(ch):
	if ch in $Party.get_children():
		selected[ch.get_index()] = null
		update_selected()
		return
		
	if ch in $Characters.get_children() && ch in selected: 
		return
		
	for i in 3:
		if !selected[i]:
			ch.modulate = Color(.1,.1,.1,1)
			selected[i] = ch
			update_selected()
			return

func update_items_ui():
	for pa in $Items.get_children(): 
		pa.visible = false
		pa.is_tabern = true
	for i in PartyManager.ITEMS_UNLOCKED.size():
		$Items.get_child(i).set_item(PartyManager.ITEMS_UNLOCKED[i])
		$Items.get_child(i).visible = true
		$Items.get_child(i).set_selected( $Items.get_child(i) in selected_items )

func _on_item_click(item_node):
	print("NODE IS ",item_node.name)
	if item_node in selected_items:
		selected_items.erase(item_node)
	else: 
		selected_items.append(item_node)
	update_items_ui()
