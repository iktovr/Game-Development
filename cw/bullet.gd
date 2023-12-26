extends CharacterBody3D

var forward = Vector3.FORWARD
var speed = 10
var asteroid_bonus = 5

@export var explosion_scene : PackedScene


func _ready():
	$AudioStreamPlayer3D.play()


func _physics_process(delta):
	if position.length() > 100:
		queue_free()
	
	var coll = move_and_collide(forward * speed * delta)
	if coll:
		if coll.get_collider() is RigidBody3D:
			if collision_layer == 128:
				get_tree().get_root().get_node("Main").update_score(asteroid_bonus)
			var explosion = explosion_scene.instantiate()
			explosion.position = coll.get_position()
			get_parent().add_child(explosion)
			coll.get_collider().queue_free()
			queue_free()

func alien_bullet():
	forward *= -1
	$MeshInstance3D.mesh.material.albedo_color = Color.RED
	$AudioStreamPlayer3D.stream = load("res://sound/alien_blaster.wav")
	$AudioStreamPlayer3D.volume_db = 0
	collision_layer = 512
	collision_mask = 0b0100011
