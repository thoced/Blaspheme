extends Spatial

export var name_item = "branche"

var isPlayer = false


func _on_Area_body_entered(body):
	if body == PlayerVariables.player:
		isPlayer = true
		

func _on_Area_body_exited(body):
	if body == PlayerVariables.player:
		isPlayer = false
		
func _input(event):
	if isPlayer:
		if event is InputEventKey:
			if event.scancode == KEY_U:
				
				if PlayerVariables.player.getPick()["collider"] == $ branche/StaticBody:
					# ajout de l'item dasn l'inventaire
					InventoryVariable.addItemInventory(name_item)
					# suppression du node
					get_tree().queue_delete(self)
			

func isItemPicked():
	var ray_lenght = 32.0
	var mouse_pos = get_viewport().get_mouse_position()
	var from = PlayerVariables.playerCamera.project_ray_origin(mouse_pos)
	var to = from + PlayerVariables.playerCamera.project_ray_normal(mouse_pos) * ray_lenght
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from,to)
	if result != null and result.size() > 0 and result["collider"] == self:
		return true
	else:
		return false
