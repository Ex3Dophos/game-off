extends Node

func _on_selectNoShirt_pressed():
	PlayerInformation.userType = 1
	Util.showGameScreen()
	
func _on_selectShirt_pressed():
	PlayerInformation.userType = 2
	Util.showGameScreen()
