extends RigidBody3D


func _ready():
	if randf() < 0.5:
		$MeshInstance3D.mesh = load("res://models/astronautB.obj")
	rotate_y(randf() * 2 * PI)
