extends Control

func init(text,pos,style="NORMAL"):
	$Label.text = text
	position = pos
	if style=="NORMAL": pass
	elif style=="DAMAGE": $Label.add_theme_color_override("font_color","#FF9090")
	else: $Label.add_theme_color_override("font_color",style)
	
	var tw = create_tween()
	tw.tween_property(self,"position:y",pos.y-50,1.5).set_ease(Tween.EASE_OUT)
	tw.tween_property(self,"modulate:a",0,1.5).set_ease(Tween.EASE_OUT)
	tw.play()
	await tw.finished
	queue_free()
