extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var monster
export var speed = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	monster = get_node("/root/Spatial/Monster")

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var ray_lenght = 1000
		var mouse_pos = get_viewport().get_mouse_position()
		print(mouse_pos)
		var from = project_ray_origin(mouse_pos)
		var to = project_ray_normal(mouse_pos) * ray_lenght
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from,to)
		if result != null:
			if result.size() != 0 and monster != null:
				monster.setTargetPosition(result["position"])
		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_Z):
		translation += -global_transform.basis.z * delta * speed
	if Input.is_key_pressed(KEY_S):
		translation += global_transform.basis.z * delta * speed
	if Input.is_key_pressed(KEY_D):
		translation += global_transform.basis.x * delta * speed
	if Input.is_key_pressed(KEY_Q):
		translation += -global_transform.basis.x * delta * speed
	
