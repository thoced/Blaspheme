extends Spatial

var lightFire
var elapsedTime = 0.0
var maxRange:float
var minRange:float

func _ready():
	maxRange = $fireLight.omni_range
	minRange = $fireLight.omni_range - 0.55
	
func _process(delta):
	elapsedTime += delta * 32
	$fireLight.omni_range = maxRange + sin(elapsedTime) * 0.1
