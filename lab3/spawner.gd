extends Node3D

@export var asteroid_scene : PackedScene

@export var origin = Vector3(0, 0, -40)

var width = 50
var height = 30

var spawn_time = 0.1
var prev_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	prev_time += delta
	if prev_time > spawn_time:
		prev_time = 0
		var pos = Vector3(randf_range(- width / 2, width / 2), randf_range(- height / 2, height / 2), 0)
		var asteroid = asteroid_scene.instantiate()
		asteroid.position = pos + origin
		asteroid.apply_force(Vector3(0, 0, 1) * 300)
		if randf() < 0.75:
			asteroid.angular_velocity = Vector3(randf_range(-0.3, 0.3), randf_range(-0.3, 0.3), randf_range(-0.3, 0.3))
		$Asteroids.add_child(asteroid)


func _on_consumer_body_entered(body):
	body.queue_free()
