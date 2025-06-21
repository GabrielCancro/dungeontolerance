extends Control

func _ready() -> void:
	$Continue.connect("button_down",_on_click)
	$ResetData.connect("button_down",_on_click_reset)
	$AddPrestige.connect("button_down",_on_click_add_prestige)
	$ExpText/Label.text = "PRESTIGIO "+str(SaveManager.DATA["prestige"])
	$ExpText/Label.text += "\nEXPEDITION "+str(SaveManager.DATA["expedition"])

func _on_click():
	GameManager.change_scene("Game")

func _on_click_reset():
	SaveManager.clear_data()

func _on_click_add_prestige():
	SaveManager.DATA["prestige"] += 1
	get_tree().reload_current_scene()
