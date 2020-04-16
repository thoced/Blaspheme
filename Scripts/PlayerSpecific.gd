extends "res://Scripts/KinematicBody.gd"

class_name PlayerSpecific

# Sound
var playIsDone = false
var playerSound
var audioDoor
var streamPasParquet = load("res://Sons/pas.wav")
var streamPasHerbe = load("res://Sons/pasHerbe.wav")
var audioOiseau

#Inventaire
var inventaire:Array setget ,getInventaire

func _ready():
	playerSound = $AudioPas
	playerSound.stream = streamPasHerbe
	playerSound.unit_db = 50.0
	playerSound.unit_size = 21.0
	playerSound.max_db = 3.0
	playerSound.pitch_scale = 1.6
	playerSound.connect("finished",self,"finish_sound")
	audioOiseau = get_node("/root/Spatial/AudioOiseau")
	
	inventaire.append("KEYGOLD")
		
func _process(delta):
	
	if onMove and !playIsDone:
		playerSound.play(1.0)
		playIsDone = true
	
	if !onMove:	
		playerSound.stop()
		playIsDone = false
		
func changeSoundPas(nameSound):
	match nameSound:
		"PARQUET":
			playerSound.stream = streamPasParquet
			playerSound.unit_db = 0.0
			playerSound.unit_size = 21.0
			playerSound.max_db = 3.0
			playerSound.pitch_scale = 1.15
			audioOiseau.stop()
		
		"CABANE":
			playerSound.stream = streamPasParquet
			playerSound.unit_db = 0.0
			playerSound.unit_size = 21.0
			playerSound.max_db = 3.0
			playerSound.pitch_scale = 1.15
		
		"HERBE":
			playerSound.stream = streamPasHerbe
			playerSound.unit_db = 50.0
			playerSound.unit_size = 21.0
			playerSound.max_db = 3.0
			playerSound.pitch_scale = 1.6
			audioOiseau.play()
		_:
			playerSound.stream = streamPasHerbe
			playerSound.unit_db = 50.0
			playerSound.unit_size = 21.0
			playerSound.max_db = 3.0
			playerSound.pitch_scale = 1.6
			audioOiseau.play()

func finish_sound():
	playIsDone = false
	
func getInventaire():
	return inventaire
	
func getPick():
	var ray_lenght = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = $NodeCamera/Camera.project_ray_origin(mouse_pos)
	var to = $NodeCamera/Camera.project_ray_normal(mouse_pos) * ray_lenght
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from,to)
	if result != null and result.size() > 0:
		return result

func getTypeGround():
	var ray_lenght = 100
	var mouse_pos = get_viewport().get_mouse_position()
	var from = transform.origin
	var to = transform.origin + (Vector3(0,-1,0) * ray_lenght)
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from,to)
	if result != null and result.size() > 0:
		return result
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
