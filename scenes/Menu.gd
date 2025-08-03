extends Control

func _ready() -> void:
	start_anim()
	$Container/VBox/btn_start.connect("button_down",on_btn_click.bind("start"))
	
func start_anim():
	$Tittle.modulate.a = 0
	$Container.modulate.a = 0
	var tw = create_tween()
	tw.tween_property($Tittle,"modulate:a",1,2).set_delay(1).set_ease(Tween.EASE_OUT)
	tw.tween_property($Container,"modulate:a",1,1).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property($Tittle,"position:x",$Tittle.position.x-150,.5).set_ease(Tween.EASE_IN_OUT)
	tw.parallel().tween_property($Container,"position:x",$Container.position.x+150,.5).set_ease(Tween.EASE_IN_OUT)
	tw.play()

func on_btn_click(code):
	if code=="start":
		GameManager.change_scene("Intro")
