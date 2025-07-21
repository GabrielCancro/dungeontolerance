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
	$ExpText/Label.text += "\nEXPEDITION "+str(SaveManager.DATA["expedition"])
	$PR/Label.text = str(int(SaveManager.DATA["prestige"]))
	HintManager.init($HintPanel)
	$CharDataPanel.visible = false
	PartyManager.ITEMS_UNLOCKED = SaveManager.DATA["items_unlocked"]
	selected_items = []
	
	for it_index in SaveManager.DATA["items_preselected"]:
		$Items.get_child(it_index).set_selected(true)
		selected_items.append($Items.get_child(it_index))
	
	selected = [null,null,null]
	for s in SaveManager.DATA["characters_preselected"]:
		_on_click_character($Characters.get_child(s-1))
	
	#SET CHARACTERS FUNCTIONS
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
	
	update_selected()
	update_items_ui()
	for it in $Items.get_children(): 
		it.connect("on_click_tabern_item",_on_item_click)
	
	if !SaveManager.DATA["ended_tabern_tuto"]:
		await $Tutorial.show_tuto("tabern1")
		await $Tutorial.show_tuto("tabern2")
		await $Tutorial.show_tuto("tabern3")
		await $Tutorial.show_tuto("tabern4")
		await $Tutorial.show_tuto("tabern5")
		await $Tutorial.show_tuto("tabern6")
		await $Tutorial.show_tuto("tabern7")
		SaveManager.DATA["ended_tabern_tuto"] = true
		SaveManager.save_store_data()

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
		var ch_index = node.get_index()
		if node.get_parent()==$Party: ch_index = selected[node.get_index()].get_index()
		var pj = PartyManager.CHARACTERS[ch_index]
		var text = pj.name.to_upper()+" "
		text += "[color=a0a0a0]" + Lang.get_text(pj.class) + "[/color]\n"
		Lang.set_text_vars(pj.stats)
		for i in 3:
			var stat = ["S","D","M"][i]
			if pj.stats[i]>0:
				text += "[color="+DiceManager.COLORS[stat]+"]"+Lang.get_text("stat_"+stat)+": +"+str(pj.stats[i])+"[/color]  "
		text += '\n'
		text += "[color=#FFC0C0]"+Lang.get_text("stat_hp")+": +"+str(pj.hp)+"[/color]  "
		text += "[color=#D0D0F0]"+Lang.get_text("stat_sanity")+": +"+str(pj.sanity)+"[/color]  \n"
		if pj.abs:
			var ab_data = PartyManager.get_ability_data(pj.abs)
			text += "\n" + Lang.get_text("ab_"+pj.abs+"_name",["TITLE"])
			text += "  "+Lang.get_req_string(ab_data["req"])
			text += "\n" + Lang.get_text("ab_"+pj.abs)
		#HintManager.set_text(text)
		$CharDataPanel/RichTextLabel.text = text
		$CharDataPanel.visible = true
		$CharDataPanel.size.y = 20 + $CharDataPanel/RichTextLabel.get_content_height()
		$CharDataPanel.position.y = get_viewport_rect().size.y - $CharDataPanel.size.y
	else: 
		node.modulate = off_color
		#HintManager.set_text()
		$CharDataPanel.visible = false

func _on_click_continue():
	PartyManager.ITEMS_EQUIPPED.clear()
	for it in selected_items: 
		var it_data = PartyManager.get_item_data(it.ab_data.name)
		PartyManager.ITEMS_EQUIPPED.append(it_data)
	PartyManager.PARTY_CHARACTERS.clear()
	for i in 3: 
		print(selected[i].get_name())
		var index = selected[i].get_index() + 1
		PartyManager.PARTY_CHARACTERS.append(index)
		print("SELECTED PARTY: ",PartyManager.PARTY_CHARACTERS)
	SaveManager.DATA["items_preselected"] = []
	for it in selected_items: SaveManager.DATA["items_preselected"].append(it.get_index())
	SaveManager.DATA["characters_preselected"] = PartyManager.PARTY_CHARACTERS
	SaveManager.save_store_data()
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
	PartyManager.DATA.HP = 0
	PartyManager.DATA.SANITY = 0
	PartyManager.ABILITIES = []
	for i in 3:
		if selected[i]: 
			var index = selected[i].get_index()
			selected[i].modulate = Color(.1,.1,.1,1)
			PartyManager.STATS["S"]+=PartyManager.CHARACTERS[index]["stats"][0]
			PartyManager.STATS["D"]+=PartyManager.CHARACTERS[index]["stats"][1]
			PartyManager.STATS["M"]+=PartyManager.CHARACTERS[index]["stats"][2]
			PartyManager.DATA.HP += PartyManager.CHARACTERS[index].hp
			PartyManager.DATA.SANITY += PartyManager.CHARACTERS[index].sanity
			if PartyManager.CHARACTERS[index]["abs"]:
				var ab_data = PartyManager.get_ability_data(PartyManager.CHARACTERS[index]["abs"])
				PartyManager.ABILITIES.append(ab_data)
	PartyManager.DATA.HPM = PartyManager.DATA.HP
	$Stats/RichTextLabel.text = "[color=#FFC0C0]"+Lang.get_text("stat_hp")+":"+str(PartyManager.DATA.HP)+"[/color]  "
	$Stats/RichTextLabel.text += "[color=#D0D0F0]"+Lang.get_text("stat_sanity")+":"+str(PartyManager.DATA.SANITY)+"[/color]\n"
	Lang.set_text_vars(PartyManager.get_stats_array())
	$Stats/RichTextLabel.text += Lang.get_text("some_stats")

func _on_click_character(ch):
	if ch in $Party.get_children():
		selected[ch.get_index()] = null
		update_selected()
		$CharDataPanel.visible = false
		return
		
	if ch in $Characters.get_children() && ch in selected: 
		return
		
	for i in 3:
		if !selected[i]:
			selected[i] = ch
			update_selected()
			return

func update_items_ui():
	for pa in $Items.get_children(): 
		pa.visible = false
		pa.is_tabern = true
	for i in PartyManager.ITEMS_UNLOCKED.size():
		var it_name = PartyManager.ITEMS_UNLOCKED[i]
		var ab_data = PartyManager.get_item_data(it_name)
		$Items.get_child(i).set_item(ab_data)
		$Items.get_child(i).visible = true
		$Items.get_child(i).set_selected( $Items.get_child(i) in selected_items )

func _on_item_click(item_node):
	
	if item_node in selected_items:
		selected_items.erase(item_node)
	else: 
		if selected_items.size()<SaveManager.DATA["prestige"]:
			selected_items.append(item_node)
		else: Effector.shake($PR)
	update_items_ui()
	$CharDataPanel.visible = false
