extends Node2D


func _process(delta):
	queue_redraw()


func _draw():
	if Input.is_action_pressed("left_click") and get_parent().mouse_over_ball == 0:
		for ball in get_parent().get_node("Balls").get_children():
			if ball.selected:
				draw_dashed_line(get_viewport().get_mouse_position(), ball.position, Color("d5d5d5"), 1, 10)
