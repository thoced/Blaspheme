extends WorldEnvironment

var random
var timeToLightning = 0.0
var elapsedTime = 0.0
var elapsedTimeLightning = 0.0
var isLightning = false
var backSkyColor:Color

# Called when the node enters the scene tree for the first time.
func _ready():
	random = RandomNumberGenerator.new()
	random.randomize()
	timeToLightning = random.randf_range(5.0,10.0)
	backSkyColor = environment.background_sky.sky_top_color
	
func _process(delta):
	elapsedTime += delta
	if !isLightning and elapsedTime > timeToLightning:
		elapsedTime = 0.0
		random.randomize()
		timeToLightning = random.randf_range(5.0,10.0)
		environment.background_sky.sky_top_color = Color.aliceblue
		isLightning = true
	elif isLightning:
		elapsedTimeLightning += delta
		if elapsedTimeLightning > 0.25:
			environment.background_sky.sky_top_color = backSkyColor
			isLightning = false
			elapsedTimeLightning = 0.0
	
	

