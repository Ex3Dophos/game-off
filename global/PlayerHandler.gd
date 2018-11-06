extends Node

var username = ""
var userType = ""

func createPlayer(playerName, type, id, camera):
	var player = preload('res://characters/player/Player.tscn').instance()
	player.set_network_master(id)
	player.name = playerName
	
	$'/root/Game/dungeon/walls'.add_child(player)
	
	var info = Network.self_data
	player.init(info.name, type, info.position, false)
	player.get_node("usernameLabel").set_text(info.name)
	
	if (camera):
		setCamera(player)
	
func setCamera(player):
	var camera = Camera2D.new()
	player.add_child(camera)
	camera.make_current() 
	
func setUserType(newUserType):
	userType = newUserType