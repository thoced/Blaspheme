extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var TargetPositionPath
export(NodePath) var NavigationPath

var NavigationNode
var TargetsNode

# Called when the node enters the scene tree for the first time.
func _ready():
	NavigationNode = get_node(NavigationPath)
	TargetsNode = get_node(TargetPositionPath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
