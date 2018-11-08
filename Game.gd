extends Node

func _ready():
	createLevel()
	PlayerHandler.createPlayer(str(get_tree().get_network_unique_id()), PlayerInformation.userType, get_tree().get_network_unique_id(), Vector2(), true)
	Network.sendConnectedToOtherPlayers()
	Network.requestConnectedPlayerInformation()
	
func _input(event):
	if Input.is_key_pressed(KEY_Q):
		Network.disconnectFromServer()
		Util.showMainScreen()
		PlayerInformation.resetPlayerInformation()
		
func createLevel():
	var level = preload('res://levels/dungeon/dungeon.tscn').instance()
	add_child(level)
	