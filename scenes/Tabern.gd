extends Control

func _ready() -> void:
	$Continue.connect("button_down",_on_click)
	$ResetData.connect("button_down",_on_click_reset)
	$ExpText/Label.text = "PRESTIGIO "+str(SaveManager.DATA["prestige"])
	$ExpText/Label.text += "\nEXPEDITION "+str(SaveManager.DATA["expedition"])

func _on_click():
	GameManager.change_scene("Game")

func _on_click_reset():
	SaveManager.clear_data()
