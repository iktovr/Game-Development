extends Node3D

@export var asteroid_scene : PackedScene
@export var astronaut_scene : PackedScene
@export var cargo_scene : PackedScene
@export var ammo_scene : PackedScene
@export var alien_scene : PackedScene

var origin = Vector3(0, 0, -60)

var width = 25
var height = 20

var spawn_time = 0.1
var prev_time = 0

var astronaut_p = 0.03
var cargo_p = 0.01
var alien_p = 0.01
var ammo_p = 0.02


func _process(delta):
	prev_time += delta
	if prev_time > spawn_time:
		prev_time = 0
		
		var pos = Vector3(randf_range(-1, 1) * width, randf_range(-1, 1) * height, 0)
		var obj
		if abs(pos.x) < get_parent().width && abs(pos.y) < get_parent().height:
			var p = randf()
			if p < astronaut_p:
				obj = astronaut_scene.instantiate()
				obj.apply_force(Vector3(0, 0, 1) * 300)
			elif p < astronaut_p + cargo_p:
				obj = cargo_scene.instantiate()
			elif p < astronaut_p + cargo_p + ammo_p:
				obj = ammo_scene.instantiate()
				obj.rotate_x(randf() * 2 * PI)
				obj.rotate_z(randf() * 2 * PI)
				obj.apply_force(Vector3(0, 0, 1) * 300)
			elif p < astronaut_p + cargo_p + ammo_p + alien_p:
				obj = alien_scene.instantiate()
			else:
				obj = asteroid_scene.instantiate()
				obj.apply_force(Vector3(0, 0, 1) * 300)
				if randf() < 0.75:
					obj.angular_velocity = Vector3(randf_range(-0.3, 0.3), randf_range(-0.3, 0.3), randf_range(-0.3, 0.3))
		else:
			obj = asteroid_scene.instantiate()
			obj.apply_force(Vector3(0, 0, 1) * 300)
			if randf() < 0.75:
				obj.angular_velocity = Vector3(randf_range(-0.3, 0.3), randf_range(-0.3, 0.3), randf_range(-0.3, 0.3))
		obj.position = pos + origin
		$Asteroids.add_child(obj)


func _on_consumer_body_entered(body):
	body.queue_free()
