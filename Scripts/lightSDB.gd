extends OmniLight

var elapsedTime = 0.0
var timeToStrobe = 0.0
var randomGenerator
var neonMesh:MeshInstance
var neonMat:SpatialMaterial

# Called when the node enters the scene tree for the first time.
func _ready():
	randomGenerator = RandomNumberGenerator.new()
	neonMesh = get_parent().get_node("neonMesh")
	neonMat = neonMesh.mesh.surface_get_material(0)
	var i = 0
	
	
func _process(delta):
	elapsedTime += delta
	if elapsedTime > timeToStrobe:
		visible = !visible
		neonMat.emission_enabled = !neonMat.emission_enabled
		timeToStrobe = randomGenerator.randf_range(0.05,0.3)
		elapsedTime = 0.0

