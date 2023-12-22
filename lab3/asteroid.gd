extends RigidBody3D

var min_radius = 1
var max_radius = 5
var radius


func _ready():
	radius = randf_range(min_radius, max_radius)
	$MeshInstance3D.scale = Vector3.ONE * radius
	$CollisionShape3D.scale = Vector3.ONE * radius
	
	if randf() < 0.3:
		$MeshInstance3D.mesh = load("res://models/meteor.obj")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
