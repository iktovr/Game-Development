extends RigidBody3D

var min_radius = 0.15
var max_radius = 0.25
var selected_color = Color.RED

var radius : float
var color : Color
var selected = false

var colors = PackedColorArray([
	"5d275d", "ef7d57", "ffcd75", "a7f070", "38b764", "257179", 
	"29366f", "3b5dc9", "41a6f6", "73eff7", "94b0c2", "566c86",
])

var prev_velocity : Vector3

func _ready():
	radius = randf_range(min_radius, max_radius)
	color = colors[randi_range(0, colors.size()-1)]
	mass = (radius / min_radius) ** 3
	$MeshInstance3D.mesh.radius = radius
	$MeshInstance3D.mesh.height = radius * 2
	$CollisionShape3D.shape.radius = radius
	
	$MeshInstance3D.mesh.material.albedo_color = color


func _physics_process(delta):
	prev_velocity = linear_velocity


func select():
	if selected:
		selected = false
		$MeshInstance3D.mesh.material.albedo_color = color
	else:
		selected = true
		$MeshInstance3D.mesh.material.albedo_color = selected_color


func random(max_pos):
	for i in range(3):
		position[i] = randf_range(-max_pos + radius, max_pos - radius)
