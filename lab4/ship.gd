extends CharacterBody3D

signal hit

var vel = Vector3.ZERO
var acc = 0.3
var damp = 2
var max_speed = 5
var angular_speed = PI / 100

var rot = Vector3.ZERO


func _physics_process(delta):
	transform = transform.orthonormalized()
	var pressed = false
	if Input.is_action_pressed("move_up"):
		rot.x += angular_speed
	if Input.is_action_pressed("move_down"):
		rot.x -= angular_speed
		
	if Input.is_action_pressed("move_left"):
		rot.y += angular_speed
	if Input.is_action_pressed("move_right"):
		rot.y -= angular_speed
		
	if Input.is_action_pressed("roll_right"):
		rot.z += angular_speed
	if Input.is_action_pressed("roll_left"):
		rot.z -= angular_speed
	
	if Input.is_action_pressed("move_forward"):
		pressed = true
		vel += -transform.basis.z * acc

	if rot.x != 0:
		rotate_object_local(Vector3.RIGHT, rot.x)
		rot.x = 0

	if rot.y != 0:
		rotate_object_local(Vector3.UP, rot.y)
		rot.y = 0
		
	if rot.z != 0:
		rotate_object_local(Vector3.FORWARD, rot.z)
		rot.z = 0
	
	if vel.length() > max_speed:
		vel = vel.normalized() * max_speed
		
	if not pressed:
		vel += -vel * damp * delta
		
	if vel.length() < 1e-2:
		$Thruster1.emitting = false
		$Thruster2.emitting = false
	else:
		$Thruster1.emitting = true
		$Thruster2.emitting = true
		
	$Thruster1.process_material.initial_velocity_max = 3 * vel.length() / max_speed
	$Thruster2.process_material.initial_velocity_max = 3 * vel.length() / max_speed
		
	var coll = move_and_collide(vel * delta)
	if coll:
		vel *= 0
		if coll.get_collider().collision_layer == 0x2: # asteroid
			hit.emit()
