extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var camera
var monster
var monster02
var ball:MeshInstance


# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node("/root/Spatial/Player/NodeCamera/Camera")
	monster = get_node("/root/Spatial/MonsterFull")
	monster02 = get_node("/root/Spatial/MonsterFull2")
	OS.window_size = Vector2(1920,1080)
	OS.window_fullscreen = true
	
	
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var ray_lenght = 1000
		var mouse_pos = get_viewport().get_mouse_position()
		print(mouse_pos)
		var from = camera.project_ray_origin(mouse_pos)
		var to = camera.project_ray_normal(mouse_pos) * ray_lenght
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from,to)
		if result != null:
			print("result: ", result.size())
			if result.size() != 0 and monster != null:
				monster.setTargetPosition(result["position"])

func _on_action(value,value2,value3):
	if value == $Player:
		print("Joueur Door: " , value )
		print("value 2: ", value2)
		print(value3)
		value2.open()

func _on_close(value,value2,value3):
	if value == $Player:
		value2.close()

func createBall(position):
	ball = MeshInstance.new()
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height  = 0.1
	ball.mesh = sphere
	get_node("/root/Spatial").add_child(ball)
