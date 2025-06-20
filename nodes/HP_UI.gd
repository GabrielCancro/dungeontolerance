extends ColorRect

func _ready():
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.connect("button_down",_on_click)

func _on_hover(val):
	pass
	#$BGColor.visible = val

func _on_click():
	pass
	#var dice = DiceManager.get_dice_drag()
	#if !dice: return
	#if (PartyManager.DATA.HP==PartyManager.DATA.HPM):
		#DiceManager.set_dice_drag(null)
		#Effector.float_text("MAX HP",global_position + Vector2(80,-20),"NORMAL") 
		#return
	#PartyManager.apply_heal(1)
	#dice.consume_dice()

func update_hp():
	$HP.text = str(PartyManager.DATA.HP)
	$HPMAX.text = str(PartyManager.DATA.HPM)
	$ProgressBar.max_value = PartyManager.DATA.HPM
	$ProgressBar.value = PartyManager.DATA.HP
