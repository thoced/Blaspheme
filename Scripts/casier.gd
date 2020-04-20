extends Spatial

var currentDoorLeft
var currentDoorRight
var openDoorLeft
var openDoorRight
var isAcceptAction = false
export var opened = false
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Spatial/Player")
	currentDoorLeft = $doorLeft.transform.basis
	currentDoorRight = $doorRight.transform.basis
	openDoorLeft = currentDoorLeft.rotated(Vector3.UP,deg2rad(-90.0))
	openDoorRight = currentDoorRight.rotated(Vector3.UP,deg2rad(90.0))
	
	
func _process(delta):
	if opened:
		$doorLeft.transform.basis = $doorLeft.transform.basis.slerp(openDoorLeft,0.02)
		$doorRight.transform.basis = $doorRight.transform.basis.slerp(openDoorRight,0.02)
	else:
		$doorLeft.transform.basis = $doorLeft.transform.basis.slerp(currentDoorLeft,0.02)
		$doorRight.transform.basis = $doorRight.transform.basis.slerp(currentDoorRight,0.02)
		

func _input(event):
	if event is InputEventKey:
		if isAcceptAction and event.pressed and event.scancode == KEY_U:
			opened = !opened

func _on_Area_body_entered(body):
	if body == player:
		isAcceptAction = true


func _on_Area_body_exited(body):
	if body == player:
		isAcceptAction = false
