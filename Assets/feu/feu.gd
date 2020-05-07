extends Spatial

var lightFire
var elapsedTime = 0.0
var maxRange:float
var minRange:float
var onPlayer = false

func _ready():
	maxRange = $fireLight.omni_range
	minRange = $fireLight.omni_range - 0.55
	
func _process(delta):
	elapsedTime += delta * 32
	$fireLight.omni_range = maxRange + sin(elapsedTime) * 0.1


func _on_Area_body_entered(body):
	if body == PlayerVariables.player:
		onPlayer = true

func _on_Area_body_exited(body):
	if body == PlayerVariables.player:
		onPlayer = false

func _input(event):
	if onPlayer:
		if event is InputEventKey and event.is_pressed():
			if event.scancode == KEY_R and PlayerVariables.player.getPick()["collider"] == $feu/StaticBody:
				var del = false
				if InventoryVariable.inventory.has("branche01"):
					InventoryVariable.delItemInventory("branche01")
					del = true
				elif InventoryVariable.inventory.has("branche02"):
					InventoryVariable.delItemInventory("branche02")
					del = true
				elif InventoryVariable.inventory.has("branche03"):
					InventoryVariable.delItemInventory("branche03")
					del = true
			
				if del:
					if !$branche01.visible:
						$branche01.visible = true
					elif !$branche02.visible:
						$branche02.visible = true
					elif !$branche03.visible:
						$branche03.visible = true	
					del = false	
			
					
				
					
		
			
