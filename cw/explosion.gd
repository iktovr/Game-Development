extends Node3D


func _ready():
	for child in $Particles.get_children():
		child.emitting = true
	$AudioStreamPlayer3D.play()


func _process(delta):
	if not $AudioStreamPlayer3D.playing:
		queue_free()
