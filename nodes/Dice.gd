extends Control

func _ready() -> void:
	$Button.connect("button_down",DiceManager.set_dice_drag.bind(self))
	#$Button.gui_input.connect(_on_button_gui_input)
#
#func _on_button_gui_input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			#print("Right click on button!")
