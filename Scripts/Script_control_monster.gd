extends Spatial

var thread_script:Thread
var monster

# Called when the node enters the scene tree for the first time.
func _ready():
	monster = get_node("/root/Spatial/MonsterFull")
	thread_script = Thread.new()
	
func start_script_monster():
	thread_script.start(self,"runScript",null)
	
func runScript(userData):
	yield(get_tree().create_timer(2.0),"timeout")
	# vers la table ronde
	monster.call_deferred("setTargetPosition",Vector3(23.514187, 8.603109, 31.090654))
	yield(monster,"matchDestination")
	yield(get_tree().create_timer(3.0),"timeout")
	# vers l'arrière du fauteuil
	monster.call_deferred("setTargetPosition",Vector3(25.111164, 8.60311, 33.23106))
	yield(monster,"matchDestination")
	monster.call_deferred("setTargetPosition",Vector3(25.301113, 8.60311, 32.419968))
	yield(get_tree().create_timer(1.0),"timeout")
	# vers la SDB
	monster.call_deferred("setTargetPosition",Vector3 (14.646298, 9.655369, 29.260733))

