extends "res://Scripts/moveKinematic.gd"

class_name MonsterSpecific

export var distanceViewPlayer:float = 24.0
export var timeToSearch:float = 2.0
var player
var elapsedTime = 0.0

func _ready():
	player = get_node("/root/Spatial/Player")

	
func _process(delta):
	# recherche du player
	elapsedTime += delta
	if elapsedTime > timeToSearch:
		elapsedTime = 0.0
		if translation.distance_to(player.translation) < distanceViewPlayer:
			var diff = translation.direction_to(player.translation)
			diff = diff.normalized()
			var dot = transform.basis.z.dot(diff)
			if dot > -0.15 and isPlayerVisible():
				setTargetPosition(player.translation)
		

func isPlayerVisible():
	var ray_lenght = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = translation
	var to = player.translation
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from,to)
	if result != null and result["collider"] == player:
		return true
	else:
		return false
		 
