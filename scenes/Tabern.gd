extends Control

var t = {}
var off_color = Color(.6,.6,.6,1)

func _ready() -> void:
	$Continue.connect("button_down",_on_click)
	$ResetData.connect("button_down",_on_click_reset)
	$AddPrestige.connect("button_down",_on_click_add_prestige)
	$ExpText/Label.text = "PRESTIGIO "+str(SaveManager.DATA["prestige"])
	$ExpText/Label.text += "\nEXPEDITION "+str(SaveManager.DATA["expedition"])
	for c in $Characters.get_children():
		var i = c.get_index()
		t["t"+str(i)] = (0.01+i%4*0.02)
		t["o"+str(i)] = i*0.4
		c.modulate = off_color
		$Buttons.get_child(i).connect("mouse_entered",_on_hover.bind(c,true))
		$Buttons.get_child(i).connect("mouse_exited",_on_hover.bind(c,false))

func _process(delta: float) -> void:
	for c in $Characters.get_children():
		var i = c.get_index()
		t["t"+str(i)] += delta * (0.02+i%3*0.02)
		c.pivot_offset = c.size * Vector2(.5,.7)
		c.rotation_degrees = sin(t["t"+str(i)]+t["o"+str(i)])*10

func _on_hover(node,val):
	if val: node.modulate = Color(1,1,1,1)
	else: node.modulate = off_color

func _on_click():
	GameManager.change_scene("Game")

func _on_click_reset():
	SaveManager.clear_data()

func _on_click_add_prestige():
	SaveManager.DATA["prestige"] += 1
	get_tree().reload_current_scene()
