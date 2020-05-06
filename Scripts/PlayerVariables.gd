extends Node

var player
var playerCamera

# movement
var onMove = false
var crounch = false
var sprint = false
var layer = false
#stamina
export var staminaMax = 100.0 
var stamina = staminaMax
export var staminaStep = 5.0
export var staminaStepRecovery = 2.0

func _ready():
	player = get_node("/root/Spatial/Player")
	playerCamera = get_node("/root/Spatial/Player/PivotCamera/NodeCamera/Camera")
