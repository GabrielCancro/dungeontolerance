extends Control

func _ready() -> void:
	$Continue.modulate.a = 0
	$Continue.connect("button_down",_on_click)
	$TextContainer.position.y = get_viewport_rect().size.y + 50
	var tw = create_tween()
	tw.tween_property($TextContainer,"position:y",16.5,15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property($Continue,"modulate:a",1,1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.play()
	await tw.finished
	$Continue.visible = true

func _on_click():
	if SaveManager.DATA["prestige"]==0: 
		GameManager.change_scene("Game")
	else:
		GameManager.change_scene("Tabern")
	
