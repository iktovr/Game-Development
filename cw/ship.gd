extends Node3D

var bullet_scene = load("res://bullet.tscn")

signal hit

var vel = Vector3.ZERO
var acc = 0.3
var damp = 2
var max_speed = 5
var hor_angle = 0
var vert_angle = 0
var angle_speed = 0.01
var max_angle = 0.4
var gameover = false
var ammo = 8


func _ready():
	get_parent().update_ammo(ammo)


func _physics_process(delta):
	if gameover:
		return
	
	$Ship.transform = $Ship.transform.orthonormalized()
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
		var body = coll.get_collider()
		if body.collision_layer == 2 || body.collision_layer == 64 || body.collision_layer == 256 || body.collision_layer == 512: # asteroid, cargo, alien, alien_bullet
			gameover = true
			var explosion = load("res://explosion.tscn").instantiate()
			explosion.position = coll.get_position()
			get_parent().add_child(explosion)
			body.queue_free()
			$Ship.queue_free()
			hit.emit()
		elif body.collision_layer == 8: # astronaut
			$Ship/Pickup.play()
			get_parent().update_astronauts(1)
			body.queue_free()
		elif body.collision_layer == 32: # ammo
			$Ship/Pickup.play()
			ammo += 4
			get_parent().update_ammo(4)
			body.queue_free()
	$Camera3D.position += $Ship.position - old_pos
		

var emitter = true

func _input(event):
	if gameover:
		return
	
	if event.is_action_pressed("shoot") && ammo > 0:
		ammo -= 1
		get_parent().update_ammo(-1)
		var bullet = bullet_scene.instantiate()
		if emitter:
			bullet.position = $Ship/BulletEmitter1.global_position
		else:
			bullet.position = $Ship/BulletEmitter2.global_position
		emitter = not emitter
		add_child(bullet)
		
	if event.is_action_pressed("infinite_ammo"):
		get_parent().update_ammo(-ammo)
		ammo = 0xffffffff
		get_parent().update_ammo(ammo)
		

func dump_astronauts():
	$Ship/Dump.play()
	get_parent().update_astronauts(-1)
