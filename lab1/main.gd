extends Node2D


@export var ball_scene: PackedScene
@export var force_strength = 10
var screen_size
var mouse_over_ball = 0


func _ready():
	screen_size = get_viewport_rect().size
	get_viewport().size_changed.connect(on_size_changed)


func _input(event):
	if event.is_action_pressed("right_click"):
		var ball = ball_scene.instantiate()
		ball.position = event.position
		ball.mouse_entered.connect(on_ball_mouse_entered)
		ball.mouse_exited.connect(on_ball_mouse_exited)
		$Balls.add_child(ball)
	elif event.is_action_released("left_click") and mouse_over_ball == 0:
		for ball in $Balls.get_children():
			if ball.selected:
				ball.apply_central_force((event.position - ball.position).normalized() * force_strength)


func on_ball_mouse_entered():
	mouse_over_ball += 1


func on_ball_mouse_exited():
	mouse_over_ball -= 1


func on_size_changed():
	screen_size = get_viewport_rect().size
	$ColorRect.size = screen_size
	$Walls/Down.position.y = screen_size.y
	$Walls/Right.position.x = screen_size.x
