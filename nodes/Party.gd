extends Control

func _ready() -> void:
	update_ui()

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
