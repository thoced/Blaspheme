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
				if PlayerVariables.player.getPick()["collider"] == self:
					# ajout de l'item dasn l'inventaire
					InventoryVariable.addItemInventory(name_item)
					# suppression du node
					get_tree().queue_delete(self)
			

