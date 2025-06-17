extends Control

func fit_node(node):
	if !node:
		visible = false
	else:
		var screen = get_viewport_rect().size
		$left.global_position = Vector2(0,0)
		$left.size = Vector2(node.global_position.x,screen.y)
		$right.global_position = Vector2(node.global_position.x+node.size.x,0)
		$right.size = Vector2(screen.x-$right.global_position.x,screen.y)
		$up.global_position = Vector2(0,0)
		$up.size = Vector2(screen.x,node.global_position.y)
		$down.global_position = Vector2(0,node.global_position.y+node.size.y)
		$down.size = Vector2(screen.x,screen.y-$down.global_position.y)
		visible = true
