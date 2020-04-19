extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed:float = 12.0
export var speedWalk = 12.0
export var speedSprint:float = 12.0
export var gravity:float = -9.81  
export var close = 0.5
var vectorGravity = Vector3(0,gravity,0)
var velocity = Vector3(0,0,0)
var indSimplePaths = -1
var nblistPosTarget = 0
var simplePaths = PoolVector3Array()
var nextTargetPos
var nextPoint setget ,getNextTargetPosition
var onMove = false
var dir : Vector3
var targetPosition : Vector3

export(NodePath) var TargetPositionPath
export(NodePath) var NavigationPath

var NavigationNode
var TargetsNode

signal matchDestination

var blendAnimation = 0.01

# Called when the node enters the scene tree for the first time.
func _ready():
	#listPosTarget = get_node("/root/Spatial/targetsNode")
	NavigationNode = get_node(NavigationPath)
	TargetsNode = get_node(TargetPositionPath)
	#nblistPosTarget = TargetsNode.get_child_count()
	nextTargetPos = $".".translation
	simplePaths.empty()
	nextPoint = translation
	set_physics_process(true)
	speed = speedWalk
	
func getNextTargetPosition():
	return nextPoint
	
func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play(anim_name)

func getSimpleNavigationPath(newTargetPosition) -> bool:
	simplePaths.empty()
	print("newTargetPosition: " , newTargetPosition)
	simplePaths = NavigationNode.get_simple_path(translation,newTargetPosition)
	indSimplePaths = -1
	if simplePaths.size() != 0:
		nextPoint = getNextPointPath()
		onMove = true
		return true
	else:
		return false
		
	

func getNextPointPath():
	indSimplePaths+=1
	if indSimplePaths < simplePaths.size(): 
		return simplePaths[indSimplePaths]
	else:
		return translation
	
	

func _physics_process(delta):
	if onMove and translation.distance_to(nextPoint) < close:
		if translation.distance_to(targetPosition) < close:
			onMove = false
		else:
			nextPoint = getNextPointPath()	
			
	# deplacement
	dir = Vector3.ZERO
	if onMove:
		dir = translation.direction_to(nextPoint)
		dir = dir.normalized()
		if dir.length() < close:
			onMove = false
			emit_signal("matchDestination")

	velocity.y -= 0.098
	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

	velocity = move_and_slide(velocity,Vector3.UP)
	
	if dir.x != 0 and dir.z != 0:
		var angle = atan2(dir.x,dir.z)
		var char_rot = get_rotation()
		char_rot.y = lerp(char_rot.y,angle,0.05)
		set_rotation(char_rot)
		
		$AnimationTree.set("parameters/transition/blend_amount", blendAnimation)
		blendAnimation += delta * 2
		if blendAnimation > 1.0:
			blendAnimation = 1.0
		#$AnimationPlayer.play("Walk",-1,0.8)
	else:
		#$AnimationTree.set("parameters/transition/blend_amount", 0.01)
		#$AnimationTree.set("parameters/Choix/current", "Walk")
		$AnimationTree.set("parameters/transition/blend_amount", blendAnimation)
		blendAnimation -= delta * 2
		if blendAnimation < 0:
			blendAnimation = 0.01
	

	
func setTargetPosition(position) -> bool:
	targetPosition = position
	#targetPosition.y += 1
	#createBall(position)
	return getSimpleNavigationPath(targetPosition)
	
func createBall(position):
	var m = MeshInstance.new()
	m.translate(position)
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height  = 0.1
	m.mesh = sphere
	get_node("/root/Spatial").add_child(m)
	
func _on_action(value):
	print("monser door !!!!")

