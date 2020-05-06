extends Panel

var textSac:Texture
var textBranche:Texture
var textTorche:Texture

func _ready():
	textSac = load("res://Textures/sac.png")
	textBranche = load("res://Textures/branche.png")
	textTorche = load("res://Textures/torche.png")

func _process(delta):
	if InventoryVariable.isUpdate():
		# suppresion des nodes enfants 
		for child in get_children():
			remove_child(child)
		# creation des nouveaux nodes sur base de l'inventaire			
		var x = 0
		for item in InventoryVariable.inventory:
			var text
			match item:
				"sac01": text = textSac
				
				"branche": text = textBranche
				
				"torche": text = textTorche
				
			createRect(text,x)
			x += 42
			
		
func createRect(text,x):
	var r = TextureRect.new()
	r.texture = text
	r.rect_size = Vector2(40,40)
	r.rect_position = Vector2(2 + x,0)
	add_child(r)
