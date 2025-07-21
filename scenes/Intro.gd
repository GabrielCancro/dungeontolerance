extends Control

func _ready() -> void:
	$Continue.modulate.a = 0
	$Continue.connect("button_down",_on_click)
	set_text()
	$TextContainer.position.y = get_viewport_rect().size.y + 50
	var tw = create_tween()
	tw.tween_property($TextContainer,"position:y",16.5,15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property($Continue,"modulate:a",1,1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.play()
	await tw.finished
	$Continue.visible = true
	
func set_text():
	$TextContainer/Value.text = Lang.get_text("tx_intro1")+"\n\n"
	$TextContainer/Value.text += Lang.get_text("tx_intro2")+"\n\n"
	$TextContainer/Value.text += Lang.get_text("tx_intro3")+"\n\n"
	$TextContainer/Value.text += Lang.get_text("tx_intro4")+"\n\n"
	$TextContainer/Value.text += Lang.get_text("tx_intro5")+"\n\n"
	$TextContainer/Value.text += Lang.get_text("tx_intro6")

func _on_click():
	if SaveManager.DATA["prestige"]==0: 
		PartyManager.PARTY_CHARACTERS = [6,1,0]
		PartyManager.STATS = {"S":2,"D":1,"M":0}
		GameManager.change_scene("Game")
	else:
		GameManager.change_scene("Tabern")
	
