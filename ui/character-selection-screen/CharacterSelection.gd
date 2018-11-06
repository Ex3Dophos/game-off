extends Node

func _on_selectNoShirt_pressed():
	PlayerInformation.userType = 1
	createGame()
	
func _on_selectShirt_pressed():
	PlayerInformation.userType = 2
	createGame()
	
func createGame():
	get_tree().change_scene('res://Game.tscn')
