extends Spatial

export var name_item = "branche"

var isPlayer = false
var mat = null

func _ready():
	for child in get_children():
		if child is MeshInstance:
			mat = child.mesh.surface_get_material(0)


func _on_Area_body_entered(body):
	if body == PlayerVariables.player:
		isPlayer = true
		
func _on_Area_body_exited(body):
	if body == PlayerVariables.player:
		isPlayer = false
		
func _input(event):
	if isPlayer:
		if event is InputEventKey:
			if event.scancode == KEY_R:
				if PlayerVariables.player.getPick()["collider"] == self:
					# ajout de l'item dasn l'inventaire
					InventoryVariable.addItemInventory(name_item)
					# suppression du node
					get_tree().queue_delete(self)
			

func _process(delta):
	pass
			
