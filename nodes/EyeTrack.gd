extends Control

func _ready() -> void:
	GameManager.EYE_TRACK_REF = self
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.focus_mode = FOCUS_NONE
	update_ui()

func _process(delta: float) -> void:
	$Tentacles.rotation_degrees += delta * 10

func update_ui():
	$Label.text = str(PartyManager.DATA.SANITY)
	$RedCircle.visible = (PartyManager.DATA.SANITY==0)
	#$Label2.text = str(PartyManager.DATA.MAX_SANITY)
	var sc = 1.0-min(float(PartyManager.DATA.SANITY)*0.1,0.5)
	print("@@@@ TENTACLES SCALE ",sc)
	$Tentacles.scale = Vector2(sc,sc)
	Effector.boom(self)

func _on_hover(val):
	$BGColor.visible = val
	var tx = Lang.get_text("stat_sanity",["TITLE","UPPER"]) + "\n" + Lang.get_text("tx_sanity")
	if val: HintManager.set_text(tx)
	else: HintManager.set_text()
