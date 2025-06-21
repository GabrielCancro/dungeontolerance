extends Control

var TargetType = "dice"
var ConditionTags = ["all"]
var AllNodes = []
signal on_chosse(node)

func _ready() -> void:
	$AnimationPlayer.play("AnimFade")
	$Cancel.connect("button_down",_on_click_cancel)
	for i in range(10):
		var hitter = $Hitters/B1.duplicate()
		$Hitters.add_child(hitter) 
	for hitter in $Hitters.get_children(): 
		hitter.connect("button_down",on_click_hitter.bind(hitter))

func _on_click_cancel():
	hide_target_chosser()
	emit_signal("on_chosse",null)

func show_target_chosser(target_type,condition_tags):
	for hitter in $Hitters.get_children(): 
		hitter.visible = false
	if target_type=="dice": AllNodes = GameManager.DICES_REF.get_children()
	elif target_type=="defiance": AllNodes = GameManager.DEFIANCES_REF.get_children()
	
	#CHECK CONDITIONS
	var result = []
	for node in AllNodes: for tag in condition_tags: 
		if tag=="is_S" && node.type=="S": result.append(node)
	AllNodes = result
	
	if AllNodes.size()>0:
		for index in AllNodes.size():
			var node = AllNodes[index]
			print("node ",index,": ",node.name)
			var hitter = $Hitters.get_child(index)
			hitter.size = node.size
			hitter.global_position = node.global_position
			hitter.visible = true
		visible = true
	else:
		Effector.float_text(Lang.get_text("no_targets"),get_viewport_rect().size/2,"NORMAL")
		await GameManager.timeout(.3)
		_on_click_cancel()

func _input(event: InputEvent) -> void:
	if !visible: return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			_on_click_cancel()

func hide_target_chosser():
	visible = false

func on_click_hitter(hitter):
	var node_chossed = AllNodes[hitter.get_index()]
	emit_signal("on_chosse",node_chossed)
	hide_target_chosser()
