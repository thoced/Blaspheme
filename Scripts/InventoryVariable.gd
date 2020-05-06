extends Node

#inventory - dictionary
var inventory:Array 
var inventoryUpdate = false setget ,isUpdate

func addItemInventory(item):
	if !inventory.has(item):
		inventory.append(item)
		inventoryUpdate = true

func isUpdate():
	var ret = inventoryUpdate
	inventoryUpdate = false
	return ret
