extends RigidBody3D

var min_radius = 1
var max_radius = 5
var radius


func _ready():
	radius = randf_range(min_radius, max_radius)
	$CollisionShape3D.shape = $MeshInstance3D.mesh.create_convex_shape()
	$MeshInstance3D.scale = Vector3.ONE * radius
	$CollisionShape3D.scale = Vector3.ONE * radius
	
	if randf() < 0.7:
		$MeshInstance3D.mesh = load("res://models/meteor_detailed.obj")
