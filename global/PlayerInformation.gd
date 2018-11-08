extends Node

var username = "Brian"
var userType = ""
var onCharacterSelection = true
var position = Vector2()

func setUsername(newUsername):
	username = newUsername
	
func setUserType(newUserType):
	userType = newUserType

func setPlayerPosition(newPosition):
	position = newPosition

func resetPlayerInformation():
	position = Vector2()
	onCharacterSelection = true
	userType = ""
	username = "Brian"