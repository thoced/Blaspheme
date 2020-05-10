extends Area

# liste des petits rochers qui vont tomber
var rocks:Array

func _ready():
	for rock in $rockFallGroup.get_children():
		if rock is RigidBody:
			rocks.append(rock)

func _on_Area_body_entered(body):
	if body == PlayerVariables.player:
		$rockFallGroup.visible = true
		for rock in rocks:
			rock.sleeping = false
		var timer = Timer.new()
		timer.connect("timeout",self,"onTimerStaticRock")
		add_child(timer)
		timer.start(10.0)
		
	
func onTimerStaticRock():
	for rock in rocks:
		rock.mode = RigidBody.MODE_STATIC
