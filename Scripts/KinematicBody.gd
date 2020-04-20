extends KinematicBody

export var Sensitivity_X = 0.0001
export var Sensitivity_Y = 0.0001
export var Invert_Y_Axis = false
export var Exit_On_Escape = true
export var Maximum_Y_Look = 45
export var Accelaration = 2.0
export var Maximum_Walk_Speed = 1.2
export var Maximum_Sprint_Speed = 0.6
export var Jump_Speed = 8.0


const GRAVITY = 0.098
var velocity = Vector3(0,0,0)
var forward_velocity = 0
var Walk_Speed = 0.0
var Sprint_Speed = 0.0
var crounch = false
var sprint = false
var layer = false
var bananeRotLeft = false
var bananeRotRight = false
var positionDown
var positionUp
var positionLayer
var radiusStanding
var heightStanding
var bananeCenter
var bananeLeft
var bananeRight
var nodeCameraZero
var deg = 0.0
var amplitude = 0.6
var speedDeg = 12
var onMove = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	forward_velocity = Walk_Speed
	set_process(true)
	
	positionUp = $PivotCamera.transform.origin
	positionDown = $PivotCamera.transform.origin + Vector3(0,-0.5,0)
	positionLayer = $PivotCamera.transform.origin + Vector3(0,-0.8,0)
	radiusStanding = $CollisionShape.shape.radius
	heightStanding = $CollisionShape.shape.height
	
	bananeCenter = $PivotCamera.transform.basis
	bananeLeft = $PivotCamera.transform.basis.rotated(Vector3.FORWARD,deg2rad(-15.0))
	bananeRight = $PivotCamera.transform.basis.rotated(Vector3.FORWARD,deg2rad(15.0))
	
	nodeCameraZero = $PivotCamera/NodeCamera.transform.basis
	
	
	
	
func _process(delta):
	if Exit_On_Escape:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()
			

func _physics_process(delta):
	velocity.y -= GRAVITY
	onMove = false
	
	if Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_UP):
		Walk_Speed += Accelaration * delta
		if Walk_Speed > Maximum_Walk_Speed + Sprint_Speed:
			Walk_Speed = Maximum_Walk_Speed + Sprint_Speed
		velocity.x = -global_transform.basis.z.x * Walk_Speed
		velocity.z = -global_transform.basis.z.z * Walk_Speed
		onMove = true
		deg += delta * speedDeg
		
		
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		Walk_Speed += Accelaration * delta
		if Walk_Speed > Maximum_Walk_Speed + Sprint_Speed:
			Walk_Speed = Maximum_Walk_Speed + Sprint_Speed
		velocity.x = global_transform.basis.z.x * Walk_Speed
		velocity.z = global_transform.basis.z.z * Walk_Speed
		onMove = true
		deg -= delta * speedDeg
		
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_Q):
		Walk_Speed += Accelaration * delta
		if Walk_Speed > Maximum_Walk_Speed + Sprint_Speed:
			Walk_Speed = Maximum_Walk_Speed + Sprint_Speed
		velocity.x = -global_transform.basis.x.x * Walk_Speed
		velocity.z = -global_transform.basis.x.z * Walk_Speed	
		onMove = true
		
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		Walk_Speed += Accelaration * delta
		if Walk_Speed > Maximum_Walk_Speed + Sprint_Speed:
			Walk_Speed = Maximum_Walk_Speed + Sprint_Speed
		velocity.x = global_transform.basis.x.x * Walk_Speed
		velocity.z = global_transform.basis.x.z * Walk_Speed
		onMove = true
		
	if Input.is_key_pressed(KEY_SHIFT):
		Sprint_Speed = Maximum_Sprint_Speed
	else:
		Sprint_Speed = 0.0
		
	if not(Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_RIGHT)):
		velocity.x = 0
		velocity.z = 0
		Walk_Speed = 0.0
		onMove = false
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = Jump_Speed
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	#crounch
	if crounch and !layer:
		var vNew = $PivotCamera.transform.origin.linear_interpolate(positionDown,0.1)
		$PivotCamera.transform.origin = vNew
	else:
		var vNew = $PivotCamera.transform.origin.linear_interpolate(positionUp,0.1)
		$PivotCamera.transform.origin = vNew
		
	#layer
	if layer:
		var vNew = $PivotCamera.transform.origin.linear_interpolate(positionLayer,0.1)
		$PivotCamera.transform.origin = vNew
		$CollisionShape.shape.radius =  lerp($CollisionShape.shape.radius,0.05,0.1)
		$CollisionShape.shape.height = lerp($CollisionShape.shape.height,0.05,0.1)
	elif !$CollisionShape/RayCastUp.is_colliding():
		var vNew = $PivotCamera.transform.origin.linear_interpolate(positionUp,0.1)
		$PivotCamera.transform.origin = vNew
		$CollisionShape.shape.height = lerp($CollisionShape.shape.height,heightStanding,0.1)
		$CollisionShape.shape.radius = lerp($CollisionShape.shape.radius,radiusStanding,0.1)
		
	
	#banane
	var isCollidingLeft = $CollisionShape/RayCastLeft.is_colliding() 
	var isCollidingRight = $CollisionShape/RayCastRight.is_colliding()
	if bananeRotLeft and !isCollidingLeft:
		var vNew = $PivotCamera.transform.basis.slerp(bananeLeft,0.1)
		$PivotCamera.transform.basis = vNew
	if bananeRotRight and !isCollidingRight:
		var vNew = $PivotCamera.transform.basis.slerp(bananeRight,0.1)
		$PivotCamera.transform.basis = vNew
	elif not(bananeRotLeft or bananeRotRight) or isCollidingLeft or isCollidingRight:
		var vNew = $PivotCamera.transform.basis.slerp(bananeCenter,0.1)
		$PivotCamera.transform.basis = vNew
		bananeRotLeft = false
		bananeRotRight = false
		
	# mouvement de roll en deplacement
	
	var roll = nodeCameraZero.rotated(Vector3.RIGHT,deg2rad(sin(deg) * amplitude))
	roll = roll.rotated(Vector3.UP,deg2rad(sin(deg * 0.5) * amplitude))
	$PivotCamera/NodeCamera.transform.basis = roll
	

	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-Sensitivity_X * event.relative.x)
		
	if event is InputEventKey:
		if event.pressed:
			if event.scancode == KEY_CONTROL:
				crounch = !crounch
			if event.scancode == KEY_W:
				crounch = false
				layer = !layer
				if !layer:
					translation += Vector3(0,(heightStanding * 2) + 0.4,0)
			if event.scancode == KEY_A:
				bananeRotLeft = !bananeRotLeft
				bananeRotRight = false
			if event.scancode == KEY_E:
				bananeRotRight = !bananeRotRight
				bananeRotLeft = false
