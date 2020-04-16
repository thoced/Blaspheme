extends Spatial

class_name porteBase

var player:PlayerSpecific
var playerOnDoor = false

var stateDoor = false
export var factorLerpDoor =  0.03
export var doorAngleOpen = 90.0
var transformFirstState
var transformSecondState

func _ready():
	player = get_node("/root/Spatial/Player")	
	$Area.connect("body_entered",self,"_on_body_entered")
	$Area.connect("body_exited",self,"_on_body_exited")
	
	transformFirstState = transform.basis
	transformSecondState = transform.basis.rotated(Vector3.UP,deg2rad(doorAngleOpen))

func _physics_process(delta):
	if stateDoor:
		transform.basis = transform.basis.slerp(transformSecondState,factorLerpDoor) 
	else:
		transform.basis = transform.basis.slerp(transformFirstState,factorLerpDoor)

func _on_body_entered(body):
	if body == player:
		print("Player est devant la porte")
		playerOnDoor = true
		
func _on_body_exited(body):
	if body == player:
		print("Player n'est plus devant la porte")
		playerOnDoor = false
	

