extends Spatial

var material:ShaderMaterial
var vec:Vector3
var sinDelta = 0.0
var del = 0.0
var random:RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	material = $sapin.get_material_override()
	if material != null:
		material.set_shader_param("sapinUniform",Vector3(1,1,1))
		
	vec = Vector3(1,0,1)
	
	random = RandomNumberGenerator.new()
	
	
func _process(delta):
	sinDelta += delta
	vec.x = sin(sinDelta) * 0.5
	vec.z = vec.x
	material.set_shader_param("sapinUniform",vec)
