extends Node

@export var width = 30
@export var height = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	$Walls/Right.position.x = width / 2
	$Walls/Left.position.x = -width / 2
	$Walls/Top.position.y = height / 2
	$Walls/Bottom.position.y = -height / 2
	
	$UI/Retry.hide()

var time = 0

func _process(delta):
	pass
#	time += delta
#	if time > 1:
#		time = 0
#		print($Spawner/Asteroids.get_child_count())


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
