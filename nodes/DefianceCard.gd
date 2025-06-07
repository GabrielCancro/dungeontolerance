extends Control

var req = {"F":10,"D":2}

func _ready() -> void:
	update_ui()

func update_ui():
	$Requisites/ReqLine1.visible = ("F" in req.keys())
