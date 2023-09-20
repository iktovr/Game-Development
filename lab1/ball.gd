extends RigidBody2D


@export var min_radius = 15
@export var max_radius = 25
var radius: float
var color: Color
var selected = false
var selected_color = Color(1, 0, 0)

var colors = PackedColorArray([
	"5d275d", "ef7d57", "ffcd75", "a7f070", "38b764", "257179", 
	"29366f", "3b5dc9", "41a6f6", "73eff7", "94b0c2", "566c86",
])


func _ready():
	radius = randf_range(min_radius, max_radius)
	mass = (radius / min_radius) ** 3
#	color = Color.from_hsv(randf_range(1./6, 5./6), 1, 1)
	color = colors[randi_range(0, colors.size()-1)]
	$CollisionShape2D.shape.set_radius(radius)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	queue_redraw()


func _draw():
	draw_circle(Vector2.ZERO, radius, selected_color if selected else color)


func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("left_click"):
		selected = not selected
		get_viewport().set_input_as_handled()
