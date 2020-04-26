extends Control

var text:String
var posText = 0
var elapsedTime = 0.0
var threadScriptDialogue

var fileOfDialogue:File
var listText
var cptListText = 0

signal EndOfText

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# chargement du fichier de dialogue
	fileOfDialogue = File.new()
	fileOfDialogue.open("res://Gui/Dialogue/file01.txt",File.READ)
	var textFile = fileOfDialogue.get_as_text()
	fileOfDialogue.close()
	if textFile != null:
		listText = textFile.split("\n")
		
	# lancement du thread script
	threadScriptDialogue = Thread.new()
	threadScriptDialogue.start(self,"scriptDialogue")
	
	
	
func setVisible(choix):
	$".".visible = choix	

func _process(delta):
	elapsedTime += delta
	if elapsedTime > 0.01:
		posText+=1
		elapsedTime = 0.0
		
	$panelDialogue/panelText.text = text.left(posText)
	if posText >= text.length():
		emit_signal("EndOfText")
	
	
# thread script qui pilote le dialogue
func scriptDialogue(userData):
	for t in listText:
		if t.length() > 0:
			text = t
			yield(self,"EndOfText")
			yield(get_tree().create_timer(3.0),"timeout")
			posText = 0		
		else:
			call_deferred("setVisible",false)
	# fin de dialogue

	

	
