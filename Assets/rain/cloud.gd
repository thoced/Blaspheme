extends Spatial

var mesh:Mesh
var meshInstance = MeshInstance.new()
var vertices = PoolVector3Array()
var matLayer01:ShaderMaterial
var matLayer02:ShaderMaterial
var color = Color(0.9, 0.1, 0.1)

var random
var elapsedTimeLayer01 = 0.0
var elapsedTimeLayer02 = 0.0
var vecLayer01:Vector3
var vecLayer02:Vector3

func _ready():
	
	random = RandomNumberGenerator.new()
	random.randomize()
	
	mesh = Mesh.new()	
	for z in range(-256,256,2):
		for x in range(-256,256,2):
			var y = random.randi_range(0,2048)
			vertices.push_back(Vector3(x,y,z))
			vertices.push_back(Vector3(x,y + 5,z))
	
	var st = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_LINES)
	for v in vertices.size():
		st.add_color(color)
		st.add_vertex(vertices[v])
	st.commit(mesh)
	
	$layer01.mesh = mesh
	matLayer01 = $layer01.material_override
	
	
func _process(delta):
	elapsedTimeLayer01 += delta
	elapsedTimeLayer02 += delta
	
	if matLayer01 != null:
		
		vecLayer01 = Vector3(0,elapsedTimeLayer01 * 10,0)
		if vecLayer01.distance_to(Vector3.ZERO) > 256.0:
			vecLayer01 = Vector3.ZERO
			elapsedTimeLayer01 = 0.0
			

		matLayer01.set_shader_param("fallParam",vecLayer01)
	

	
	
