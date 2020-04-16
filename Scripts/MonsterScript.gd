extends Node

class_name MonsterScript
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var monster

var tScript
# Called when the node enters the scene tree for the first time.
func _ready():
	monster = get_parent()
	tScript = Thread.new()
	tScript.start(self,"runScriptMovement",monster)
	
func runScriptMovement(userData):
	print("dans le run script")
	var door01  = get_node("/root/Spatial/door3")
	var door02  = get_node("/root/Spatial/door")
	var lumiere:OmniLight = get_node("/root/Spatial/superhouse/lumiere")

	yield(get_tree().create_timer(9.0),"timeout")
	monster.setTargetPosition(Vector3(23.309483, 3.20568, 27.120047))
	yield(userData,"matchDestination")
	monster.setTargetPosition(Vector3(23.554092, 3.20568, 24.268576))
	yield(userData,"matchDestination")
	monster.setTargetPosition(Vector3(24.211824, 3.20568, 23.98794))
	yield(userData,"matchDestination")
	
	# ouverture de la première porte
	door01.open()
	yield(get_tree().create_timer(4.0),"timeout")
	
	#fermeture de la lumière
	lumiere.visible = false
	
	monster.setTargetPosition(Vector3(16.480085, 3.20568, 24.153437))
	
	#ouverture de la seconde porte
	door02.open()
	
	var i = 0
	for i in range(1000):
		lumiere.visible = !lumiere.visible
		yield(get_tree().create_timer(0.05),"timeout")
	
