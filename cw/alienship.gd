extends CharacterBody3D

@export var bullet_scene : PackedScene
@export var explosion_scene : PackedScene

var vel = Vector3(0, 0, 5)
var alien_bonus = 30
var shoot_time = 0.7

func _ready():
	$CollisionShape3D.shape = $MeshInstance3D.mesh.create_convex_shape()
	vel.z += randf_range(5, 15)


var time = 0
var emitter = true


func _process(delta):
	time += delta
	if time > shoot_time:
		time = 0
		var bullet = bullet_scene.instantiate()
		bullet.alien_bullet()
		if emitter:
			bullet.position = $BulletEmitter1.position
		else:
			bullet.position = $BulletEmitter2.position
		emitter = not emitter
		add_child(bullet)


func _physics_process(delta):
	var coll = move_and_collide(vel * delta)
	
	if coll:
		var body = coll.get_collider()
		if body.collision_layer == 2 || body.collision_layer == 64:
			var explosion = explosion_scene.instantiate()
			explosion.position = coll.get_position()
			get_parent().add_child(explosion)
			body.queue_free()
		elif body.collision_layer == 128:
			var explosion = explosion_scene.instantiate()
			explosion.position = coll.get_position()
			get_parent().add_child(explosion)
			get_tree().get_root().get_node("Main").update_score(alien_bonus)
			body.queue_free()
			queue_free()
