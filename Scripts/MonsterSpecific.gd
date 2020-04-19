extends "res://Scripts/moveKinematic.gd"

class_name MonsterSpecific

# info recherche
export var distanceViewPlayer:float = 24.0
export var distanceClosestPlayer:float = 2.0
export var timeToSearch:float = 2.0
var player
var distance = 0.0
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

#variable DEBUG
var modeGUI
var positionGUI
var distanceGUI
var speedGUI

func _ready():
	player = get_node("/root/Spatial/Player")
	nodePatrouille = get_node(PathPatrouille)
	nbPositionPatrouille = nodePatrouille.get_child_count()
	random = RandomNumberGenerator.new()
	var i  = random.randi_range(0,nbPositionPatrouille - 1)
	nextPositionPatrouille = nodePatrouille.get_child(i).translation
	setTargetPosition(nextPositionPatrouille)
	
	#debug
	modeGUI = get_node("/root/Spatial/modeGui/mode")
	positionGUI = get_node("/root/Spatial/modeGui/newPosition")
	distanceGUI = get_node("/root/Spatial/modeGui/distance")
	speedGUI = get_node("/root/Spatial/modeGui/speed")
	
func _process(delta):
	elapsedTime += delta
	elapsedTimeChasse += delta
	elapsedTimeIdle += delta
	if elapsedTime > timeToSearch:
		elapsedTime = 0.0
	else:
		return
	
	# recherche du player
	ia(delta)
	match mode:
		"PATROUILLE":patrouille()
			
		"CHASSE":chasse()
		
		"SEEKHIDE":seekhide()
		
		"IDLE":idle()
			
		_:patrouille()
		
	# DEBUG
	modeGUI.text = "mode: " + mode
	positionGUI.text = "position: " + String(nextPositionPatrouille)
	distanceGUI.text = "distance: " + String(distance)
	speedGUI.text = "speed: " + String(speed)
		
func ia(delta):
	# calcul de la distance entre le monstre et le joueur
	distance = to_global($head.translation).distance_to(player.translation)
			  
	# si la distance est inférieur à distanceClosestPlayer et que le joueur est visible
	# (evite que le joueur qui tourne autour du monstre le rend invisible une fois derrière)
	if distance < distanceClosestPlayer and isPlayerVisible():
		setMode("CHASSE")
		elapsedTimeChasse = 0.0
		nextPositionPatrouille = NavigationNode.get_closest_point(player.translation)
		return
	# si la distance est inférieur à distanceView Player
	if distance < distanceViewPlayer:
		var diff = to_global($head.translation).direction_to(player.translation)
		diff = diff.normalized()
		var dot = transform.basis.z.dot(diff)
		if dot > -0.15 and isPlayerVisible():
			setMode("CHASSE")
			elapsedTimeChasse = 0.0
			nextPositionPatrouille = NavigationNode.get_closest_point(player.translation)
		else:
			if elapsedTimeChasse > 20.0: # après 20 secondes où le joueur est perdu, le monstre retourne en mode patrouille
				setMode("PATROUILLE")
			elif mode == "CHASSE": # avant les 20 secondes, le monstre est mode recherche du joueur caché
				# le monstre ne voit plus le joueur, il se met en mode recherche d'une personne cachée
				setMode("SEEKHIDE")
	
func idle():
	if elapsedTimeIdle > 2.0:
		setMode("PATROUILLE")
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
		if !setTargetPosition(nextPositionPatrouille):
			# la position trouvée ne peut être atteinte par l'algo, on reposition la nextPositionPatrouille à l'emplacement
			# exacte du monstre
			nextPositionPatrouille = NavigationNode.get_closest_point(translation)
		
	
func chasse():
	setTargetPosition(nextPositionPatrouille)
	
func patrouille():
	if translation.distance_to(nextPositionPatrouille) < 1.0 and nbPositionPatrouille > 0:
		var indRandom = random.randi_range(0,nbPositionPatrouille - 1)
		nextPositionPatrouille = NavigationNode.get_closest_point(nodePatrouille.get_child(indRandom).translation)
		setMode("IDLE")
		elapsedTimeIdle = 0.0
	
	elif !setTargetPosition(nextPositionPatrouille):
		# la position trouvée ne peut être atteinte par l'algo, on reposition la nextPositionPatrouille à l'emplacement
		# exacte du monstre
		nextPositionPatrouille = NavigationNode.get_closest_point(translation)

	
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
		
func setMode(m):
	mode = m 
	match mode:
		"IDLE": speed = speedWalk
		"PATROUILLE": speed = speedWalk
		"CHASSE": speed = speedSprint
		"SEEKHIDE": speed = speedWalk
		_: speed = speedWalk
		
	# modification de la vitesse d'animation en fonction de la vitesse
	$AnimationTree.set("parameters/TuleScale/scale", speed)
