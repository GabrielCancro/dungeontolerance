extends Control

func _ready() -> void:
	update_ui()
	update_shield()
	$Shield.modulate.a = 0

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
		Effector.boom($Shield)
	else: 
		Effector.fade_down($Shield)
