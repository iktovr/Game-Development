extends Camera3D

var angular_speed = PI / 360 * 7

var r : float = 6.5
var rot = Vector3(0, 0 ,0)
var middle_mouse_button_pressed = false


func _ready():
	position.z = r


func _process(delta):
	transform = transform.orthonormalized()
	if Input.is_action_pressed('move_left'):
		rot.y -= angular_speed
	if Input.is_action_pressed('move_right'):
		rot.y += angular_speed
		
	if Input.is_action_pressed('move_up'):
		rot.x -= angular_speed
	if Input.is_action_pressed('move_down'):
		rot.x += angular_speed
		
	if Input.is_action_pressed('roll_left'):
		rot.z -= angular_speed
	if Input.is_action_pressed('roll_right'):
		rot.z += angular_speed
		
	if Input.is_action_just_pressed('scroll_up'):
		r -= 0.2
		position = position.normalized() * r
	if Input.is_action_just_pressed('scroll_down'):
		r += 0.2
		position = position.normalized() * r
		
	if Input.is_action_just_pressed('reset_camera'):
		position = Vector3(0, 0, r)
		transform.basis = Basis()
	
	if rot.x != 0:
		position = Vector3.ZERO
		rotate_object_local(Vector3.RIGHT, rot.x)
		translate(Vector3(0, 0, r))
		rot.x = 0

	if rot.y != 0:
		position = Vector3.ZERO
		rotate_object_local(Vector3.UP, rot.y)
		translate(Vector3(0, 0, r))
		rot.y = 0
		
	if rot.z != 0:
		position = Vector3.ZERO
		rotate_object_local(Vector3.FORWARD, rot.z)
		translate(Vector3(0, 0, r))
		rot.z = 0

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		middle_mouse_button_pressed = event.is_pressed()
		
	if event is InputEventMouseMotion and middle_mouse_button_pressed:
		var norm = -event.relative.normalized()
		rot.x = norm.y * angular_speed
		rot.y = norm.x * angular_speed
