extends Spatial

var player:PlayerSpecific
var playerOnDoor = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Spatial/Player")
	$Area.connect("body_entered",self,"playerEntered")
	$Area.connect("body_exited",self,"playerExited")
	
func _input(event):
	if event is InputEventKey:
		if playerOnDoor and event.is_pressed() and event.scancode == KEY_U:
			print("Proche de la clé")
			var results = player.getPick()
			if results["collider"] == $StaticBody:
				get_tree().queue_delete(self)
				

func _exit_tree():
	player.inventaire.append("KEYGOLD")


func playerEntered(body):
	if body == player:
		playerOnDoor = true
	
func playerExited(body):
	if body == player:
		playerOnDoor = false
