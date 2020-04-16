extends Area

var player:PlayerSpecific

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Spatial/Player")


func _on_AreaSoundParquet_body_entered(body):
	if body == player:
		player.changeSoundPas("PARQUET")


func _on_AreaSoundParquet_body_exited(body):
	if body == player:
		player.changeSoundPas("HERBE")
		

func _on_AreaSoundCabane_body_entered(body):
	if body == player:
		player.changeSoundPas("CABANE")


func _on_AreaSoundCabane_body_exited(body):
	if body == player:
		player.changeSoundPas("HERBE")
