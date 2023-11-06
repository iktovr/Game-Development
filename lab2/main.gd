extends Node3D

@export var ball_scene : PackedScene
var box_size : float = 3.5
var force_strength = 2500
var middle_mouse_button_pressed = false


func _ready():
	for i in range(6):
		var wall = CollisionShape3D.new()
		wall.shape = WorldBoundaryShape3D.new()
		wall.shape.plane.normal = Vector3.ZERO
		wall.shape.plane.normal[i / 2] = 1 if i % 2 == 0 else -1
		wall.position[i / 2] = wall.shape.plane.normal[i / 2] * -1 / 2.
		$Walls.add_child(wall)
		
	$Box.scale = Vector3(box_size, box_size, box_size)
	$Walls.scale = Vector3(box_size, box_size, box_size) * 0.95
	
	var count = 5
	var angle = 0
	for i in range(count):
		var light = DirectionalLight3D.new()
		light.rotate_object_local(Vector3.RIGHT, -PI / 2)
		light.rotate_object_local(Vector3.UP, angle)
		light.translate(Vector3(0, 0, -10))
		$Lights.add_child(light)
		angle += 2 * PI / count
		
	count = 3
	angle = 0
	for i in range(count):
		var light = DirectionalLight3D.new()
		light.rotate_object_local(Vector3.UP, angle)
		light.translate(Vector3(0, 0, -10))
		$Lights.add_child(light)
		angle += 2 * PI / count


func _process(delta):
	if Input.is_action_pressed("spawn_ball"):
		var ball = ball_scene.instantiate()
		ball.random(box_size / 2)
		$Balls.add_child(ball)
	
	if Input.is_action_pressed("increase_box"):
		box_size += 0.1
		$Box.scale = Vector3(box_size, box_size, box_size)
		$Walls.scale = Vector3(box_size, box_size, box_size) * 0.95
	if Input.is_action_pressed("decrease_box") and box_size > 0:
		box_size -= 0.1
		$Box.scale = Vector3(box_size, box_size, box_size)
		$Walls.scale = Vector3(box_size, box_size, box_size) * 0.95


func ray_cast(space_state, from, to, mask):
	var query = PhysicsRayQueryParameters3D.create(from, to, mask)
	return space_state.intersect_ray(query)


func _input(event):
	if event.is_action_pressed("clear"):
		for ball in $Balls.get_children():
			ball.queue_free()
	
	elif event is InputEventMouseButton:
		var from = $Camera.project_ray_origin(event.position)
		var normal = $Camera.project_ray_normal(event.position)
		var to = from + normal * 1000
		from -= normal * 1000
			
		var space_state = get_world_3d().direct_space_state
		
		if event.is_action_pressed("left_click"):
			if $Slider.visible:
				var target = $Slider.get_dot_pos()
				$Slider.clear()
				for ball in $Balls.get_children():
					if ball.selected:
						ball.apply_central_force((target - ball.position).normalized() * force_strength)
				return
			
			var result = ray_cast(space_state, from, to, 0x0004) # ball
			
			if not result.is_empty():
				result['collider'].select()
				return
			
			result = ray_cast(space_state, from, to, 0x0002) # box
			if result.is_empty():
				return
			
			var intersect = result['position']
			result = ray_cast(space_state, to, from, 0x0002) # box
			if result.is_empty():
				return
				
			$Slider.draw(intersect, result['position'])
			
		if event.is_action_pressed("right_click"):
			if $Slider.visible:
				var target = $Slider.get_dot_pos()
				$Slider.clear()
				var ball = ball_scene.instantiate()
				ball.position = target
				$Balls.add_child(ball)
				return
			
			var result = ray_cast(space_state, from, to, 0x0002) # box
			if result.is_empty():
				return
			
			var intersect = result['position']
			result = ray_cast(space_state, to, from, 0x0002) # box
			if result.is_empty():
				return
				
			$Slider.draw(intersect, result['position'])
