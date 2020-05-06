extends "res://Scripts/moveKinematic.gd"

class_name MonsterSpecific

# info recherche
export var distanceViewPlayer:float = 24.0
export var distanceClosestPlayer:float = 2.0
export var timeToSearch:float = 2.0
var timeToIdle = 2.0
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
var nextPositionChasse:Vector3
var backTranslation:Vector3
var mode = "PATROUILLE"  
var seekHideCpt = 0
var chasseCpt = 0
#variable DEBUG
var modeGUI
var positionGUI
var distanceGUI
var speedGUI
var elapsedTimeGUI

func _ready():
	player = get_node("/root/Spatial/Player")
	nodePatrouille = get_node(PathPatrouille)
	nbPositionPatrouille = nodePatrouille.get_child_count()
	random = RandomNumberGenerator.new()
	random.randomize()
	var i  = random.randi_range(0,nbPositionPatrouille - 1)
	nextPositionPatrouille = nodePatrouille.get_child(i).translation
	setTargetPosition(nextPositionPatrouille)
	
	#debug
	modeGUI = get_node("/root/Spatial/modeGui/mode")
	positionGUI = get_node("/root/Spatial/modeGui/newPosition")
	distanceGUI = get_node("/root/Spatial/modeGui/distance")
	speedGUI = get_node("/root/Spatial/modeGui/speed")
	elapsedTimeGUI = get_node("/root/Spatial/modeGui/elapsedTimeChasse")
	
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
	elapsedTimeGUI.text ="elapsedTimeChasse: " + String(elapsedTimeChasse)
		
func ia(delta):
	# calcul de la distance entre le monstre et le joueur
	distance = to_global($head.translation).distance_to(player.translation)
			  
	# si la distance est inférieur à distanceClosestPlayer et que le joueur est visible
	# (evite que le joueur qui tourne autour du monstre le rend invisible une fois derrière)
	if distance < distanceClosestPlayer and isPlayerVisible(distance):
		setMode("CHASSE")
		elapsedTimeChasse = 0.0
		nextPositionPatrouille = NavigationNode.get_closest_point(player.translation)
		return
	# si la distance est inférieur à distanceView Player
	if distance < distanceViewPlayer:
		var diff = to_global($head.translation).direction_to(player.translation)
		diff = diff.normalized()
		var dot = transform.basis.z.dot(diff)
		if dot > -0.15 and isPlayerVisible(distance):
			setMode("CHASSE")
			elapsedTimeChasse = 0.0
			nextPositionPatrouille = NavigationNode.get_closest_point(player.translation)
		else:
			if elapsedTimeChasse > 20.0: # après 20 secondes où le joueur est perdu, le monstre retourne en mode patrouille
				setMode("PATROUILLE")
			elif mode == "CHASSE": # avant les 20 secondes, le monstre est mode recherche du joueur caché
				# le monstre ne voit plus le joueur, il se met en mode recherche d'une personne cachée
				setMode("SEEKHIDE")
				seekHideCpt = 0
	
func idle():
	if elapsedTimeIdle > 2.0:
		setMode("PATROUILLE")
		elapsedTimeIdle = 0.0
					
func seekhide():
	# or backTranslation sert à eviter que le seekHide bloque si le monstre ne bouge plus
	if translation.distance_to(nextPositionPatrouille) < 1.0:
		seekHideCpt += 1
		# si le monstre vient juste de passer en monde SEEKHIDE alors il se dirige pour la première fois dans
		# la même direction que le player puisqu'il vient juste de la quitter des yeux donc doit au moins savoir dans quelle
		# directoin il est parti
		if seekHideCpt < 2: 
			nextPositionPatrouille = NavigationNode.get_closest_point(player.translation)
			setTargetPosition(nextPositionPatrouille)
		else:
			var forward = transform.basis.z
			var angle = random.randf_range(-90.0,90.0)
			var newForward = forward.rotated(Vector3.UP,angle)
			var distance = random.randf_range(1.0,3.0)
			newForward = newForward.normalized()
			var seekPosition = translation + newForward * distance
			nextPositionPatrouille = NavigationNode.get_closest_point(seekPosition)
			if !setTargetPosition(nextPositionPatrouille):
				# la position trouvée ne peut être atteinte par l'algo, on reposition la nextPositionPatrouille à l'emplacement
				# exacte du monstre
				nextPositionPatrouille = NavigationNode.get_closest_point(translation)
		
	backTranslation = translation
	
func chasse():
	if chasseCpt > 1:
		# la position tombe toujours sur un endroit inaccessible pour le monstre ex: navmesh isolé, alors on va diviser
		# la distance entre la position du monstre et la position du joueur pour trouver une position intermédiaire
		var direction = translation.direction_to(nextPositionChasse)
		var distance = translation.distance_to(nextPositionChasse)
		direction = direction.normalized()
		nextPositionChasse = direction * (distance  * 0.5)
		nextPositionChasse = NavigationNode.get_closest_point(nextPositionChasse)
		nextPositionPatrouille = nextPositionChasse
		
	if !setTargetPosition(nextPositionPatrouille):
		chasseCpt += 1
		nextPositionPatrouille = NavigationNode.get_closest_point(nextPositionPatrouille)
		nextPositionChasse = nextPositionPatrouille
	else:
		chasseCpt = 0
	
func patrouille():
	if translation.distance_to(nextPositionPatrouille) < 1.0 and nbPositionPatrouille > 0:
		random.randomize()
		var indRandom = random.randi_range(0,nbPositionPatrouille - 1)
		nextPositionPatrouille = NavigationNode.get_closest_point(nodePatrouille.get_child(indRandom).translation)
		setMode("IDLE")
		timeToIdle = createTimeForIdle()
		elapsedTimeIdle = 0.0
	
	elif !setTargetPosition(nextPositionPatrouille):
		# la position trouvée ne peut être atteinte par l'algo, on reposition la nextPositionPatrouille à l'emplacement
		# exacte du monstre
		nextPositionPatrouille = NavigationNode.get_closest_point(translation)

	
func isPlayerVisible(distance):
	
	# si le joueur est caché dans l'herbe alors le monstre ne le voit pas à condition que la distance soit inférieur
	# à distanceClosestPlayer
	if PlayerVariables.isHideInGrass == true and (PlayerVariables.crounch or PlayerVariables.layer) and distance > distanceClosestPlayer:
		return false
		
	var ray_lenght = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = to_global($head.translation)
	var to = player.translation
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from,to)
	if result != null and result.size() > 0 and result["collider"] == player:
		return true
	else:
		return false

func createTimeForIdle():
	random.randomize()
	return random.randf_range(2.0,5.0)

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
