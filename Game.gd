extends Node

func _ready():
	#get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	#get_tree().connect('server_disconnected', self, '_on_server_disconnected')
	
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
	
#func _on_player_disconnected(id):
	#print("someone disconnected")
	#$'/root/Game/dungeon/walls'.get_node(str(id)).queue_free()
	
#func _on_server_disconnected():
	#get_tree().change_scene('res://ui/main-screen/MainScreen.tscn')
