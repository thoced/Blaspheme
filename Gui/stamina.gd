extends ColorRect

var player:PlayerSpecific

func _ready():
	player = get_node("/root/Spatial/Player")

func _process(delta):
	$".".margin_right =  lerp($".".margin_right,player.stamina,0.05)
	if player.stamina < 25.0:
		$".".color = $".".color.linear_interpolate(Color.red,0.01)
	else:
		$".".color = $".".color.linear_interpolate(Color.white,0.01)
		
