extends MeshInstance3D

@export var camera: Camera3D

var from: Vector3
var to: Vector3
var dot: float
var material
var is_drawn = false
var dot_r = 0.05


func _ready():
	material = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE_SMOKE
	

func draw(_from, _to):
	clear()
	from = _from
	to = _to
	dot = 0
	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	mesh.surface_add_vertex(from)
	mesh.surface_add_vertex(to)
	mesh.surface_end()
	$Dot.position = from
	show()


func get_dot_pos():
#	return from * (1 - dot) + to * dot
	return $Dot.position


func clear():
	mesh.clear_surfaces()
	hide()


func _input(event):
	if not visible:
		return
	
	if event is InputEventMouseMotion:
		var relative = camera.project_position(event.relative, max(camera.position.length(), 1)) - camera.project_position(Vector2.ZERO, max(camera.position.length(), 1))
		dot = clamp(dot + 0.5 * relative.dot(to - from) / (from - to).length_squared(), 0, 1)

		$Dot.position = from * (1 - dot) + to * dot
