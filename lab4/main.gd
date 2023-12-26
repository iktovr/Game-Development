extends Node

@export var asteroid_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$UI/Retry.hide()
		
	for block in $Station/Blocks.get_children():
		block.get_child(0, true).get_child(0, true).get_child(0, true).collision_mask = 0x3
		block.get_child(0, true).get_child(0, true).get_child(0, true).collision_layer = 0x4
	
	for i in range(300):
		var asteroid = asteroid_scene.instantiate()
		asteroid.position = Vector3(randf_range(-50, 50), randf_range(-5, 15), randf_range(-50, 50))
		if randf() < 0.75:
			asteroid.angular_velocity = Vector3(randf_range(-0.3, 0.3), randf_range(-0.3, 0.3), randf_range(-0.3, 0.3))
		var force = Vector3(randf(), randf(), randf()).normalized()
		force *= randf_range(1, 10)
		asteroid.apply_central_force(force)
		$Asteroids.add_child(asteroid)


func _on_ship_hit():
	$UI/Retry.show()
	get_tree().paused = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UI/Retry.visible:
		get_tree().paused = false
		get_tree().reload_current_scene()


func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
