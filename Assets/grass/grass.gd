extends Spatial
	
func _on_Area_body_entered(body):
	if body == PlayerVariables.player:
		PlayerVariables.isHideInGrass = true


func _on_Area_body_exited(body):
	if body == PlayerVariables.player:
		PlayerVariables.isHideInGrass = false
