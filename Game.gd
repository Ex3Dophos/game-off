extends Node

func _ready():
	createLevel()
	PlayerHandler.createPlayer(str(get_tree().get_network_unique_id()), PlayerInformation.userType, get_tree().get_network_unique_id(), true)
	Network.sendConnectedToOtherPlayers()
	Network.requestConnectedPlayerInformation()
	
func _input(event):
	if Input.is_key_pressed(KEY_Q):
		Network.disconnectFromServer()
		Util.showMainScreen()
		#$'/root/Game/dungeon/walls'.get_node(str(get_tree().get_network_unique_id())).queue_free()
		#get_tree().change_scene('res://ui/main-screen/MainScreen.tscn')
				
func createLevel():
	var level = preload('res://levels/dungeon/dungeon.tscn').instance()
	add_child(level)
