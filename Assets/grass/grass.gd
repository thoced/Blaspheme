extends Spatial

var player

func _ready():
	player = get_node("/root/Spatial/Player")


func _on_Area_body_entered(body):
	if body == player:
		player.isHideInGrass = true


func _on_Area_body_exited(body):
	if body == player:
		player.isHideInGrass = false
