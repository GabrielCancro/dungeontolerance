extends Control

func _ready() -> void:
	update_ui()

func update_ui():
	$Stats/RichTextLabel.text = Lang.get_text("all_party_stats")
	$HP/HPVALUE.text = str(PartyManager.DATA.HP) + "/" + str(PartyManager.DATA.HPM)

func damage_fx():
	Effector.damage($Retraits)
	Effector.boom_big($HP)
	update_ui()
