extends CharacterBody3D

var vel = Vector3(0, 0, 5)

@export var explosion_scene : PackedScene


func _ready():
	if randf() < 0.5:
		$MeshInstance3D.mesh = load("res://models/craft_cargoB.obj")
	$CollisionShape3D.shape = $MeshInstance3D.mesh.create_convex_shape()
	rotate_y(randf_range(0, 2 * PI))


func _physics_process(delta):
	var coll = move_and_collide(vel * delta)
	
	if coll:
		var body = coll.get_collider()
		if body.collision_layer == 2 || body.collision_layer == 256:
			var explosion = explosion_scene.instantiate()
			explosion.position = coll.get_position()
			get_parent().add_child(explosion)
			body.queue_free()
		elif body.collision_layer == 512:
			queue_free()


func _on_area_3d_body_entered(body):
	body.get_parent().dump_astronauts()
