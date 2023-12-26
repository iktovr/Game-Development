extends Node

# ship boundaries
var width = 15
var height = 15

var score = 0
var astronauts = 0
var ammo = 0
var gameover = false
var astronaut_bonus = 10

@export var ship_scene : PackedScene
@export var spawner_scene : PackedScene


func _ready():
	$Walls/Right.position.x = width
	$Walls/Left.position.x = -width
	$Walls/Top.position.y = height
	$Walls/Bottom.position.y = -height
	
	$UI/Retry.hide()
	$UI/HUD.hide()
	$Ship.hide()
	get_tree().paused = true

var time = 0
var score_time = 5


func _process(delta):
	time += delta
	if time > score_time:
		if not $Music.playing:
			$Music.play()
		if not gameover:
			update_score(1)
		time = 0
		

func update_score(count):
	if gameover:
		return
	score += count
	$UI/HUD/Score/Score.text = str(score)


func update_astronauts(count):
	if gameover:
		return
	if count < 0:
		update_score(astronaut_bonus * astronauts)
		astronauts = 0
	else:
		astronauts += count
	$UI/HUD/Astronauts/Label.text = str(astronauts)


func update_ammo(count):
	if gameover:
		return
	ammo += count
	$UI/HUD/Ammo/Label.text = str(ammo)


func _on_ship_hit():
	$UI/Retry/Score.text = "Your score is %s" % score
	$UI/Retry.show()
	gameover = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if gameover:
			$UI/Retry/Button.pressed.emit()
		elif $UI/Start.visible:
			$UI/Start/Button.pressed.emit()
			


func _on_start_pressed():
	$UI/Start.hide()
	$UI/HUD.show()
	$Ship.show()
	get_tree().paused = false


func _on_restart_pressed():
	gameover = false
	
	update_astronauts(-1)
	update_score(-score)
	update_ammo(-ammo)
	
	$Ship.name = "ShipDel"
	$ShipDel.queue_free()
	var ship = ship_scene.instantiate()
	ship.name = "Ship"
	add_child(ship)
	$Ship.hit.connect(_on_ship_hit.bind())
	
	$Spawner.name = "SpawnerDel"
	$SpawnerDel.queue_free()
	var spawner = spawner_scene.instantiate()
	spawner.name = "Spawner"
	add_child(spawner)
	
	$UI/Retry.hide()
