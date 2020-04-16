extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 16
var gravity = -9.81
var vectorGravity = Vector3(0,gravity,0)
var velocity = Vector3(0,0,0)
var listPosTarget
var nblistPosTarget = 0
var indSimplePaths = 0
var simplePaths = PoolVector3Array()
var nextTargetPos
var nextPoint

# Called when the node enters the scene tree for the first time.
func _ready():
	listPosTarget = get_node("/root/Spatial/targetsNode")
	nblistPosTarget = listPosTarget.get_child_count()
	nextTargetPos = $".".translation
	nextPoint = nextTargetPos

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getNewTargetPosition():
	if nblistPosTarget > 0:
		var random = RandomNumberGenerator.new()
		random.randomize()
		var nb = random.randi_range(0,nblistPosTarget - 1)
		return listPosTarget.get_child(nb).translation
	else:
		return null

func getSimpleNavigationPath(newTargetPosition):
	simplePaths.empty()
	simplePaths = $Navigation.get_simple_path(translation,newTargetPosition)
	if simplePaths == null or simplePaths.size() == 0:
		print("Bordel")
		
	simplePaths.push_back(newTargetPosition)
	indSimplePaths = 0
	
	
	
func getNextPointPath():
	indSimplePaths += 1
	return simplePaths[indSimplePaths - 1]
	

func _physics_process(delta):
	
	#selection d'une position 3d target
	if nextTargetPos.distance_to($".".translation) < 1:
		nextTargetPos = getNewTargetPosition()
		getSimpleNavigationPath(nextTargetPos)
		nextPoint = getNextPointPath()
		
				
	# detection des distances avec les nextpoint
	if translation.distance_to(nextPoint) < 1:
		nextPoint = getNextPointPath()
		

	# deplacement
	var dir = translation.direction_to(nextPoint)
	dir = dir.normalized()
	move_and_slide((dir * speed) + vectorGravity)
	print(nextPoint)

	

