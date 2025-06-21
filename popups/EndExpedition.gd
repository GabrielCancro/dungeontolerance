extends Control

func _ready() -> void:
	$Panel/Continue.connect("button_down",_on_click)
	
func _on_click():
	GameManager.change_scene("Tabern")
