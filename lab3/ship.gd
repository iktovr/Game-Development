extends Node3D

signal hit

var vel = Vector3.ZERO
var acc = 0.3
var damp = 2
var max_speed = 5
var hor_angle = 0
var vert_angle = 0
var angle_speed = 0.01
var max_angle = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Ship.transform = $Ship.transform.orthonormalized()


func _physics_process(delta):
	var pressed = false
	if Input.is_action_pressed("move_up"):
		pressed = true
		vel += Vector3.UP * acc
		if vert_angle + angle_speed < max_angle:
			vert_angle += angle_speed
			
	elif Input.is_action_pressed("move_down"):
		pressed = true
		vel += Vector3.DOWN * acc
		if -(vert_angle - angle_speed) < max_angle:
			vert_angle -= angle_speed
			
	else:
		vert_angle -= sign(vert_angle) * min(abs(vert_angle), angle_speed)
			
	if Input.is_action_pressed("move_left"):
		pressed = true
		vel += Vector3.LEFT * acc
		if -(hor_angle - angle_speed) < max_angle:
			hor_angle -= angle_speed 
			
	elif Input.is_action_pressed("move_right"):
		pressed = true
		vel += Vector3.RIGHT * acc
		if hor_angle + angle_speed < max_angle:
			hor_angle += angle_speed
			
	else:
		hor_angle -= sign(hor_angle) * min(abs(hor_angle), angle_speed)
	
	$Ship.transform.basis = Basis()
	$Ship.rotate_object_local(Vector3.FORWARD, hor_angle)
	$Ship.rotate_object_local(Vector3.RIGHT, vert_angle)
	
	if vel.length() > max_speed:
		vel = vel.normalized() * max_speed
		
	if not pressed:
		vel += -vel * damp * delta
		
	var old_pos = $Ship.position
	var coll = $Ship.move_and_collide(vel * delta)
	if coll:
		vel *= 0
		if coll.get_collider().collision_layer == 0x2: # asteroid
			hit.emit()
	$Camera3D.position += $Ship.position - old_pos
		
