extends Control

var t = [0,.4,.8]

func _ready() -> void:
	$Button.connect("button_down",set_retraits)
	$Shield/Button.connect("button_down",on_click_shield)
	$Shield/Button.connect("mouse_entered",_on_hover_shield.bind(true))
	$Shield/Button.connect("mouse_exited",_on_hover_shield.bind(false))
	update_ui()
	update_shield()
	#$Shield.modulate.a = 0
	set_retraits()

func set_retraits():
	$Character1.pivot_offset = $Character1.size * Vector2(.50,.75)
	$Character2.pivot_offset = $Character2.size * Vector2(.50,.75)
	$Character3.pivot_offset = $Character3.size * Vector2(.50,.75)
	$Character1.texture = load("res://assets/characters/c"+str(PartyManager.PARTY_CHARACTERS[1])+".png")
	$Character2.texture = load("res://assets/characters/c"+str(PartyManager.PARTY_CHARACTERS[2])+".png")
	$Character3.texture = load("res://assets/characters/c"+str(PartyManager.PARTY_CHARACTERS[0])+".png")

func _process(delta: float) -> void:
	t[0] += delta*.8
	t[1] += delta*.9
	t[2] += delta
	$Character1.rotation_degrees = sin(t[0])*3
	$Character2.rotation_degrees = sin(t[1])*3
	$Character3.rotation_degrees = sin(t[2])*3


func _on_hover_shield(val):
	$BGColorShield.visible = val

func update_ui():
	Lang.set_text_vars(PartyManager.get_stats_array())
	$Stats/RichTextLabel.text = Lang.get_text("some_stats")
	$HP_UI.update_hp()

func damage_fx():
	Effector.damage($Retraits)
	Effector.boom_big($HP_UI)
	update_ui()

func healt_fx():
	Effector.boom_big($HP_UI)
	update_ui()

func update_shield():
	$Shield/block.visible = (PartyManager.DATA.SH==0)
	if (PartyManager.DATA.SH>0):
		$Shield/Label.text = str(PartyManager.DATA.SH)
		await Effector.boom($Shield)
	else:
		$Shield/Label.text = "0"
		await GameManager.timeout(.5)

func on_click_shield():
	var dice = DiceManager.get_dice_drag()
	if !dice: return
	dice.consume_dice()
	PartyManager.DATA.SH += 1
	update_shield()
