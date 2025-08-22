extends CanvasLayer

func _ready() -> void:
	fade_out()
	print("TRANSITION INSTANTIATED!!!")

func fade_in():
	var tw = create_tween()
	tw.tween_property($BG,"modulate:a",1,.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tw.play()
	await tw.finished

func fade_out():
	var tw = create_tween()
	tw.tween_property($BG,"modulate:a",0,.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tw.play()
	await tw.finished
