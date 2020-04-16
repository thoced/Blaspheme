extends "res://Scripts/porteBase.gd"

class_name porteMaison

func _ready():
	pass

func _input(event):
	if playerOnDoor:
		if event is InputEventKey:
			if event.pressed and event.scancode == KEY_U:
				if player.inventaire.has("KEYGOLD"):
					stateDoor = !stateDoor
					if stateDoor:
						$DoorUnlockSound.play(4.09)
				elif !$DoorLockSound.playing:
					$DoorLockSound.play(0.0)
					$Timer.start(0.75)
					
					
func _on_Timer_EndSoundDoor():
	$DoorLockSound.stop()

