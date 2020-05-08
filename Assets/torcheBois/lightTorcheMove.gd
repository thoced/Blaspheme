extends OmniLight
var x:Array
var y:Array
var z:Array
var random
var elapsedTime = 0.0
var ind = 0
var posInit:Vector3
var omniRangeInit:float

# Called when the node enters the scene tree for the first time.
func _ready():
	posInit = translation
	omniRangeInit = omni_range
	random = RandomNumberGenerator.new()
	random.randomize()
	for i in range(0,16):
		x.append(random.randf_range(-0.01,0.01))
		y.append(random.randf_range(-0.01,0.01))
		z.append(random.randf_range(-0.01,0.01))
		
func _process(delta):
	elapsedTime += delta
	if elapsedTime > 0.2:
		elapsedTime = 0.0
		translation = posInit
		translate(Vector3(x[ind],y[ind],z[ind]))
		omni_range = omniRangeInit
		omni_range += x[ind] * 6
		ind += 1
		if ind > 15:
			ind = 0
		

