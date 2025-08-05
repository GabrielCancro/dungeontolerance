extends Control

func _ready() -> void:
	localizate()
	start_anim()
	$Container/VBox/btn_start.connect("button_down",on_btn_click.bind("start"))
	$Container/VBox/btn_lang.connect("button_down",on_btn_click.bind("lang"))
	$Container/VBox/btn_reset.connect("button_down",on_btn_click.bind("reset"))
	$Container/VBox/btn_reset/btn_reset_sure.connect("button_down",on_btn_click.bind("reset_sure"))
	$Container/VBox/btn_reset/btn_reset_sure.connect("mouse_exited",on_btn_click.bind("reset_sure_hover"))
	
func start_anim():
	$Tittle.modulate.a = 0
	$Container.modulate.a = 0
	var tw = create_tween()
	tw.tween_property($Tittle,"modulate:a",1,1).set_delay(1).set_ease(Tween.EASE_OUT)
	tw.tween_property($Container,"modulate:a",1,1).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property($Tittle,"position:x",$Tittle.position.x-150,.5).set_ease(Tween.EASE_IN_OUT)
	tw.parallel().tween_property($Container,"position:x",$Container.position.x+150,.5).set_ease(Tween.EASE_IN_OUT)
	tw.play()

func localizate():
	$Container/VBox/btn_start.text = Lang.get_text("ui_start")
	$Container/VBox/btn_lang.text = Lang.get_text("ui_languaje")+": "+Lang.current_lang
	$Container/VBox/btn_reset.text = Lang.get_text("ui_reset_data")
	$Container/VBox/btn_reset/btn_reset_sure.text = Lang.get_text("ui_reset_data_sure")

func on_btn_click(code):
	if code=="start":
		GameManager.change_scene("Intro")
	elif code=="lang":
		if Lang.current_lang=="en": Lang.current_lang = "es"
		else: Lang.current_lang = "en"
		SaveManager.save_store_data()
		localizate()
	elif code=="reset":
		$Container/VBox/btn_reset/btn_reset_sure.visible = true
	elif code=="reset_sure":
		SaveManager.clear_data()
	elif code=="reset_sure_hover":
		$Container/VBox/btn_reset/btn_reset_sure.visible = false
