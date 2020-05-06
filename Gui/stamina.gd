extends ColorRect

func _process(delta):
	$".".margin_right =  lerp($".".margin_right,PlayerVariables.stamina,0.05)
	if PlayerVariables.stamina < 25.0:
		$".".color = $".".color.linear_interpolate(Color.red,0.01)
	elif PlayerVariables.stamina < 50.0:
		$".".color = $".".color.linear_interpolate(Color.orange,0.01)
	elif PlayerVariables.stamina < 75.0:
		$".".color = $".".color.linear_interpolate(Color.greenyellow,0.01)
	else:
		$".".color = $".".color.linear_interpolate(Color.green,0.01)		
