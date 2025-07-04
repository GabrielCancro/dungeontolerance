extends Control

signal on_close

func _ready() -> void:
	$HintPanel/Button.connect("button_down",_on_click)

func show_tuto(code):
	$HintPanel/RichTextLabel.text = Lang.get_text("tuto_"+code)
	$HintPanel.size.y = 20 + $HintPanel/RichTextLabel.get_content_height()
	var node = GameManager.PARTY_REF
	if code == "welcome": node = GameManager.PARTY_REF
	if code == "party": node = GameManager.PARTY_REF.get_node("Stats")
	if code == "dices": node = GameManager.DICES_REF
	if code == "rat1": node = DefianceManager.ALL_DEFIANCES[0].node
	if code == "rat2": node = DefianceManager.ALL_DEFIANCES[0].node.get_node("Stats")
	if code == "rat3": node = DefianceManager.ALL_DEFIANCES[0].node.get_node("Abilities")
	if code == "rat4": node = DefianceManager.ALL_DEFIANCES[0].node
	if code == "good_work": GameManager.DICES_REF
	if code == "ability1": node = GameManager.PARTY_ABILITIES_REF.get_child(0)
	if code == "power1": node = GameManager.PARTY_REF
	if code == "power2": node = GameManager.POWERGEM_REF
	if code == "shield": node = GameManager.PARTY_REF.get_node("Shield")
	if code == "end": node = GameManager.PARTY_REF
	
	if code == "tabern1": node = get_node("/root/Tabern/TutoPoints/Table")
	if code == "tabern2": node = get_node("/root/Tabern/PR")
	if code == "tabern3": node = get_node("/root/Tabern/Items").get_child(0)
	if code == "tabern4": node = get_node("/root/Tabern/TutoPoints/Characters")
	if code == "tabern5": node = get_node("/root/Tabern/TutoPoints/Party")
	if code == "tabern6": node = get_node("/root/Tabern/Continue")
	if code == "tabern7": node = get_node("/root/Tabern/TutoPoints/Table")

	$Cutter.fit_node(node)
	var hint_pos = node.global_position + Vector2(node.size.x/2-$HintPanel.size.x/2,-$HintPanel.size.y-30)
	if hint_pos.x < 10: hint_pos.x = 10
	if hint_pos.y < 100: hint_pos.y = node.global_position.y+250
	Effector.move_to($HintPanel,hint_pos)
	Effector.appear_less($HintPanel)
	visible = true
	await on_close

func _on_click():
	visible = false
	emit_signal("on_close")
