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
var bananeRotLeft = false
var bananeRotRight = false
var scaledStanding
var scaledLayer
var scaledCrounch
var bananeCenter
var bananeLeft
var bananeRight
var nodeCameraZero
var deg = 0.0
var amplitude = 0.6
var speedDeg = 12
#stamina
export var staminaMax = 100.0 
var stamina = staminaMax
export var staminaStep = 5.0
export var staminaStepRecovery = 2.0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	forward_velocity = Walk_Speed
	set_process(true)
	
	# scale pour la positoin platventre et crounch
	scaledStanding = scale
	scaledLayer = scale * 0.1
	scaledCrounch = scale * 0.5

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
	PlayerVariables.onMove = false
	
	if Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_UP):
		Walk_Speed += Accelaration * delta
		if Walk_Speed > Maximum_Walk_Speed + Sprint_Speed:
			Walk_Speed = Maximum_Walk_Speed + Sprint_Speed
		velocity.x = -global_transform.basis.z.x * Walk_Speed
		velocity.z = -global_transform.basis.z.z * Walk_Speed
		PlayerVariables.onMove = true
		deg += delta * speedDeg
		
		
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		Walk_Speed += Accelaration * delta
		if Walk_Speed > Maximum_Walk_Speed + Sprint_Speed:
			Walk_Speed = Maximum_Walk_Speed + Sprint_Speed
		velocity.x = global_transform.basis.z.x * Walk_Speed
		velocity.z = global_transform.basis.z.z * Walk_Speed
		PlayerVariables.onMove = true
		deg -= delta * speedDeg
		
	if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_Q):
		Walk_Speed += Accelaration * delta
		if Walk_Speed > Maximum_Walk_Speed + Sprint_Speed:
			Walk_Speed = Maximum_Walk_Speed + Sprint_Speed
		velocity.x = -global_transform.basis.x.x * Walk_Speed
		velocity.z = -global_transform.basis.x.z * Walk_Speed	
		PlayerVariables.onMove = true
		
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
		Walk_Speed += Accelaration * delta
		if Walk_Speed > Maximum_Walk_Speed + Sprint_Speed:
			Walk_Speed = Maximum_Walk_Speed + Sprint_Speed
		velocity.x = global_transform.basis.x.x * Walk_Speed
		velocity.z = global_transform.basis.x.z * Walk_Speed
		PlayerVariables.onMove = true
		
	if Input.is_key_pressed(KEY_SHIFT) and (PlayerVariables.stamina > PlayerVariables.staminaStep):
		InventoryVariable.addItemInventory("sac01")
		Sprint_Speed = Maximum_Sprint_Speed
		PlayerVariables.sprint = true
		# modification du stamina
		if PlayerVariables.onMove:
			PlayerVariables.stamina -= PlayerVariables.staminaStep * delta
			if PlayerVariables.stamina < 0.0:
				PlayerVariables.stamina = 0.0
	else:
		Sprint_Speed = 0.0
		PlayerVariables.sprint = false
		# modification du stamina
		PlayerVariables.stamina += PlayerVariables.staminaStepRecovery * delta
		if PlayerVariables.stamina > PlayerVariables.staminaMax:
			PlayerVariables.stamina = PlayerVariables.staminaMax
				
	if not(Input.is_key_pressed(KEY_Z) or Input.is_key_pressed(KEY_Q) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_DOWN) or Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_RIGHT)):
		velocity.x = 0
		velocity.z = 0
		Walk_Speed = 0.0
		PlayerVariables.onMove = false
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = Jump_Speed
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	#crounch & layer
	if PlayerVariables.crounch and !PlayerVariables.layer:
		scale = scale.linear_interpolate(scaledCrounch,0.1)
	elif PlayerVariables.layer:
		scale = scale.linear_interpolate(scaledLayer,0.1)
	else:
		scale = scale.linear_interpolate(scaledStanding,0.1)
		
	
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
				PlayerVariables.crounch = !PlayerVariables.crounch
				InventoryVariable.addItemInventory("branche")
			if event.scancode == KEY_W:
				InventoryVariable.addItemInventory("torche")
				PlayerVariables.crounch = false
				PlayerVariables.layer = !PlayerVariables.layer
			if event.scancode == KEY_A:
				bananeRotLeft = !bananeRotLeft
				bananeRotRight = false
			if event.scancode == KEY_E:
				bananeRotRight = !bananeRotRight
				bananeRotLeft = false
