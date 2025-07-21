extends Control

func _ready() -> void:
	$Panel/Continue.connect("button_down",_on_click)
	$Panel/RichTextLabel.text = Lang.get_text("tx_game_over")
	
func _on_click():
	GameManager.change_scene("Tabern")
