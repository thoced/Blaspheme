extends Node

class_name Inventaire

var inventaire = {} setget setInventaire,getInventaire

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func getInventaire():
	return inventaire
	
func setInventaire(val):
	inventaire = val

func addNewItem(item,nameItem):
	var value = {nameItem : item}
	inventaire.values().append(value)
	
func isItemInInventaire(nameItem):
	return inventaire.has(nameItem)
	
func getItemInInventaire(nameItem):
	return inventaire.get(nameItem)
