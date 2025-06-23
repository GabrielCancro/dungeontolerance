extends Control

var t = [0,.4,.8]
var char = [1,2,3,4,5,6,7]

func _ready() -> void:
	$Button.connect("button_down",set_retraits)
	update_ui()
	update_shield()
	$Shield.modulate.a = 0
	set_retraits()

func set_retraits():
	randomize()
	char.shuffle()
	$Character1.pivot_offset = $Character1.size * Vector2(.50,.75)
	$Character2.pivot_offset = $Character1.size * Vector2(.50,.75)
	$Character3.pivot_offset = $Character1.size * Vector2(.50,.75)
	$Character1.texture = load("res://assets/characters/c"+str(char[0])+".png")
	$Character2.texture = load("res://assets/characters/c"+str(char[1])+".png")
	$Character3.texture = load("res://assets/characters/c"+str(char[2])+".png")

func _process(delta: float) -> void:
	t[0] += delta*.8
	t[1] += delta*.9
	t[2] += delta
	$Character1.rotation_degrees = sin(t[0])*3
	$Character2.rotation_degrees = sin(t[1])*3
	$Character3.rotation_degrees = sin(t[2])*3

func update_ui():
	$Stats/RichTextLabel.text = Lang.get_text("all_party_stats")
	$HP_UI.update_hp()

func damage_fx():
	Effector.damage($Retraits)
	Effector.boom_big($HP_UI)
	update_ui()

func healt_fx():
	Effector.boom_big($HP_UI)
	update_ui()

func update_shield():
	if (PartyManager.DATA.SH>0):
		$Shield.modulate.a = 1
		$Shield/Label.text = str(PartyManager.DATA.SH)
		await Effector.boom($Shield)
	else: 
		await Effector.fade_down($Shield)
