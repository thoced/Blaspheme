extends Spatial

var currentTransform
var openTransformDotPositif
var openTransformDotNegatif
var monster
var player
var opened = 0
var elapsedTimeOpened = 0.0
var isAcceptAction = false

export var maxAngleOpen:float = 150.0

func _ready():
	monster = get_node("/root/Spatial/MonsterFull")
	player = get_node("/root/Spatial/Player")
	currentTransform = $door.transform.basis
	# preparation des deux transformations pour l'ouverture positif et negative de la porte
	openTransformDotPositif = currentTransform.rotated(Vector3.UP,deg2rad(-maxAngleOpen))
	openTransformDotNegatif = currentTransform.rotated(Vector3.UP,deg2rad(maxAngleOpen))
	
func _process(delta):
	# si le dot product est positif, utilisation de la transformation positive
	var trans
	if opened > 0:
		trans = $door.transform.basis.slerp(openTransformDotPositif,0.02)
		$door.transform.basis = trans
		elapsedTimeOpened += delta
		if elapsedTimeOpened > 2.0:
			opened = 0
			elapsedTimeOpened = 0.0

	# si le dot product est negatif, utilisation de la transformation negative
	if opened < 0:
		trans = $door.transform.basis.slerp(openTransformDotNegatif,0.02)
		$door.transform.basis = trans
		elapsedTimeOpened += delta
		if elapsedTimeOpened > 2.0:
			opened = 0
			elapsedTimeOpened = 0.0
			
	# sinon fermeture de la porte avec la transformation current
	elif opened == 0:
		trans = $door.transform.basis.slerp(currentTransform,0.02)
		$door.transform.basis = trans
		if $door.transform.basis.is_equal_approx(currentTransform):
			$door/StaticBody/CollisionShape.disabled = false
	
func _on_Area_body_shape_entered(body_id, body, body_shape, area_shape):
	if body == monster:
			computeSideOfDoorOpen(monster)
			$door/StaticBody/CollisionShape.disabled = true
	elif body == player:
		# c'est le player qui touche la porte, on accepte une action d'ouverture si demandée
		acceptAction()
		
func computeSideOfDoorOpen(body):
	
	var dir = body.translation.direction_to(translation)
	dir = dir.normalized()
	var dot = transform.basis.x.dot(dir)
	if dot < 0.0:
		opened = -1
	else:
		opened = 1
		
func acceptAction():
	isAcceptAction = true
	
func refuseAction():
	isAcceptAction = false
	
func _input(event):
	if isAcceptAction:
		if event is InputEventKey:
			if event.scancode == KEY_U:
				computeSideOfDoorOpen(player)
		
	
func _on_Area_body_shape_exited(body_id, body, body_shape, area_shape):
	if body == player:
		refuseAction()

		
