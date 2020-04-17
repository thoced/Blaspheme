extends "res://Scripts/moveKinematic.gd"

class_name MonsterSpecific

# info recherche
export var distanceViewPlayer:float = 24.0
export var timeToSearch:float = 2.0
var player
var elapsedTime = 0.0
var elapsedTimeChasse = 0.0
var elapsedTimeIdle = 0.0

#variable de patrouille
export(NodePath) var PathPatrouille
var nodePatrouille
var nbPositionPatrouille = 0
var random:RandomNumberGenerator
var nextPositionPatrouille:Vector3
var mode = "PATROUILLE"  

func _ready():
	player = get_node("/root/Spatial/Player")
	nodePatrouille = get_node(PathPatrouille)
	nbPositionPatrouille = nodePatrouille.get_child_count()
	random = RandomNumberGenerator.new()
	var i  = random.randi_range(0,nbPositionPatrouille - 1)
	nextPositionPatrouille = nodePatrouille.get_child(i).translation
	setTargetPosition(nextPositionPatrouille)
	
func _process(delta):
	elapsedTime += delta
	elapsedTimeChasse += delta
	elapsedTimeIdle += delta
	if elapsedTime > timeToSearch:
		elapsedTime = 0.0
	else:return
	
	# recherche du player
	ia(delta)
	match mode:
		"PATROUILLE":patrouille()
			
		"CHASSE":chasse()
		
		"SEEKHIDE":seekhide()
		
		"IDLE":idle()
			
		_:patrouille()
		
	print("mode: ",mode, " elapsed: ",elapsedTimeChasse)
		
func ia(delta):
		if translation.distance_to(player.translation) < distanceViewPlayer:
			var diff = translation.direction_to(player.translation)
			diff = diff.normalized()
			var dot = transform.basis.z.dot(diff)
			if dot > -0.15 and isPlayerVisible():
				mode = "CHASSE"
				elapsedTimeChasse = 0.0
				nextPositionPatrouille = NavigationNode.get_closest_point(player.translation)
			else:
				if elapsedTimeChasse > 20.0:
					mode = "PATROUILLE"
					elapsedTimeChasse = 0.0
				elif mode == "CHASSE":
					# le monstre ne voit plus le joueur, il se met en mode recherche d'une personne cachée
					mode = "SEEKHIDE"
	
func idle():
	if elapsedTimeIdle > 2.0:
		mode = "PATROUILLE"
		elapsedTimeIdle = 0.0
					
func seekhide():
	if translation.distance_to(nextPositionPatrouille) < 1.0:
		var forward = transform.basis.z
		var angle = random.randf_range(-90.0,90.0)
		var newForward = forward.rotated(Vector3.UP,angle)
		var distance = random.randi_range(1,8)
		newForward = newForward.normalized()
		var seekPosition = translation + newForward * distance
		nextPositionPatrouille = NavigationNode.get_closest_point(seekPosition)
		setTargetPosition(nextPositionPatrouille)
		
	
func chasse():
	setTargetPosition(nextPositionPatrouille)
		
func patrouille():
	if translation.distance_to(nextPositionPatrouille) < 1.0 and nbPositionPatrouille > 0:
		var indRandom = random.randi_range(0,nbPositionPatrouille - 1)
		nextPositionPatrouille = NavigationNode.get_closest_point(nodePatrouille.get_child(indRandom).translation)
		mode = "IDLE"
		elapsedTimeIdle = 0.0
	
	setTargetPosition(nextPositionPatrouille)
	
	
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
		 
