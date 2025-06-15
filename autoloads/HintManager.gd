extends Node

var HintPanel
var BBLabel:RichTextLabel

func init(_hint_panel):
	HintPanel = _hint_panel
	HintPanel.visible = false
	BBLabel = HintPanel.get_node("RichTextLabel")

func set_text(_text=null):
	HintPanel.visible = (_text!=null)
	set_process(_text!=null)
	if !_text: return
	BBLabel.text = _text
	HintPanel.size.y = 20 + BBLabel.get_content_height()

func _process(delta: float) -> void:
	var offset = Vector2(20,20)
	if DiceManager.get_dice_drag(): offset =Vector2(60,60)
	HintPanel.position = get_viewport().get_mouse_position() + offset
	if HintPanel.position.x > 600: HintPanel.position.x -= HintPanel.size.x/2 + offset.x
	if HintPanel.position.x > 800: HintPanel.position.x -= HintPanel.size.x/2 
	if HintPanel.position.y+HintPanel.size.y > 600: HintPanel.position.y -= HintPanel.size.y + offset.y
