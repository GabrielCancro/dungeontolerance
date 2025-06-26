extends Control

func _ready() -> void:
	for L in $Panel/VBox.get_children():
		L.get_node("Button").connect("button_down",_on_click.bind(L.get_index()+1))
		L.get_node("Button").connect("mouse_entered",_on_hover.bind(L,true))
		L.get_node("Button").connect("mouse_exited",_on_hover.bind(L,false))
	show_destine("")

func show_destine(code):
	visible = true
	for L in $Panel/VBox.get_children(): L.get_node("Border").visible = false

func _on_click(val):
	print("CHOSSE "+str(val))

func _on_hover(node,val):
	node.get_node("Border").visible = val
