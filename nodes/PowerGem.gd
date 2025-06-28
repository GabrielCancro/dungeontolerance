extends Control

var max_amount = 3
var gems = {"S":[],"D":[],"M":[],"OFF":[]}

func _ready() -> void:
	visible = false
	$Button.connect("mouse_entered",_on_hover.bind(true))
	$Button.connect("mouse_exited",_on_hover.bind(false))
	$Button.connect("button_down",on_click)
	order_points()
	off_all()
	update_colors()

func _on_hover(val):
	$BGColor.visible = val

func _process(delta: float) -> void:
	$ball.rotation_degrees += delta*30
	$BGColor.rotation = $ball.rotation
	$Points.rotation_degrees -= delta*20

func order_points():
	var amount:float = $Points.get_child_count()
	const dist = 35
	for p in $Points.get_children():
		var i:float = p.get_index()
		p.position = Vector2(cos(i/amount*2*PI)*dist,sin(i/amount*2*PI)*dist)
		p.position -= p.size/2

func off_all():
	gems = {"S":[],"D":[],"M":[],"OFF":$Points.get_children()}
	
func update_colors():
	for g in gems["S"]: g.modulate = DiceManager.COLORS.S
	for g in gems["D"]: g.modulate = DiceManager.COLORS.D
	for g in gems["M"]: g.modulate = DiceManager.COLORS.M
	for g in gems["OFF"]: g.modulate = Color(.3,.3,.3,1)

func inc_gems(type,val):
	if gems[type].size()>=max_amount: return false
	if gems["OFF"].size()<val: return false
	randomize()
	gems["OFF"].shuffle()
	for i in val: 
		var _gem = gems["OFF"].pop_back()
		Effector.appear_less($ball)
		Effector.boom_big(_gem)
		gems[type].append(_gem)
		
	update_colors()
	return true

func dec_gems(type,val):
	if gems[type].size()<val: return false
	randomize()
	gems[type].shuffle()
	for i in val: gems["OFF"].append(gems[type].pop_back())
	update_colors()
	return true

func clear_gems():
	for g in gems["S"]: gems["OFF"].append(gems["S"].pop_back())
	for g in gems["D"]: gems["OFF"].append(gems["D"].pop_back())
	for g in gems["M"]: gems["OFF"].append(gems["M"].pop_back())

func has_gems(type,val=1):
	var result = (gems[type].size()>=val)
	if !result: 
		Effector.shake(self)
		GameManager.timeout(.7)
	return result

func on_click():
	for k in ["S","D","M","OFF"]: print(k,gems[k].size())
	var dice = DiceManager.get_dice_drag()
	if !dice: return
	var result = inc_gems(dice.type,1)
	if result: dice.consume_dice()
	else: Effector.float_text(Lang.get_text("max_power"),global_position + Vector2(80,-20),"NORMAL") 

func show_powergem():
	modulate.a = 0
	visible = true
	await Effector.appear_less(self)
