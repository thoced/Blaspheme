extends Spatial

var random
var timeToLightningForward = 0.0
var timeToLightningBackward = 0.0
var elapsedTime = 0.0
var elapsedTimeLightningForward = 0.0
var elapsedTimeLightningBackward = 0.0
var timerForward:Timer
var timerBackward:Timer
var backSkyColor:Color

# Called when the node enters the scene tree for the first time.
func _ready():
	random = RandomNumberGenerator.new()
	random.randomize()
	timeToLightningForward =  random.randf_range(4.0,8.0)
	timeToLightningBackward =  random.randf_range(4.0,8.0)
	timerForward = Timer.new()
	timerBackward = Timer.new()
	timerForward.connect("timeout",self,"timeOutForward")
	timerBackward.connect("timeout",self,"timeOutBackward")
	add_child(timerForward)
	add_child(timerBackward)

	
func _process(delta):
	elapsedTimeLightningForward += delta
	elapsedTimeLightningBackward += delta
	if elapsedTimeLightningForward > timeToLightningForward:
		$SunLight.visible = false
		$lightningForward.visible = true
		elapsedTimeLightningForward = 0.0	
		timeToLightningForward
		timerForward.start(0.05)
		timeToLightningForward =  random.randf_range(4.0,8.0)
		
	if elapsedTimeLightningBackward > timeToLightningBackward:
		$SunLight.visible = false
		$lightningBackward.visible = true
		elapsedTimeLightningBackward = 0.0
		timerBackward.start(0.05)
		timeToLightningBackward =  random.randf_range(4.0,8.0)
		
func timeOutForward():
	$SunLight.visible = true
	$lightningForward.visible = false

func timeOutBackward():
	$SunLight.visible = true
	$lightningBackward.visible = false
		
		
	
	

