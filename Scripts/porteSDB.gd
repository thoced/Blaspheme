extends "res://Scripts/porteBase.gd"

class_name porteSDB

var scriptControlMonster

func _ready():
	scriptControlMonster = get_node("/root/Spatial/Script_control_monster")

func _input(event):
	if playerOnDoor:
		if event is InputEventKey:
			if event.pressed and event.scancode == KEY_U:
				if player.inventaire.has("KEYGOLD"):
					stateDoor = !stateDoor
					if stateDoor:
						$DoorUnlockSound.play(4.09)
						var timerOutlast = Timer.new()
						add_child(timerOutlast)
						timerOutlast.connect("timeout",self,"startMusicOutlast")
						timerOutlast.one_shot = true
						timerOutlast.start(2.0)
						scriptControlMonster.start_script_monster()
						
						
				elif !$DoorLockSound.playing:
					$DoorLockSound.play(0.0)
					$Timer.start(0.75)
					
					
func _on_Timer_EndSoundDoor():
	$DoorLockSound.stop()

func startMusicOutlast():
	$OutlastSound.play()
