extends Node

var username = ""
var userType = ""

func createPlayer(playerName, type, id, camera):
	print("Player " + playerName + " is being created.")
	
	var player
	
	if type == 1:
		player = load('res://characters/player/sprites/hero/Hero.tscn').instance()
	if type == 2:
		player = load('res://characters/player/sprites/skeleton/Skeleton.tscn').instance()
	
	player.set_network_master(id)
	player.name = playerName
	
	$'/root/Game/dungeon/walls'.add_child(player)
	
	var info = Network.self_data
	player.init(info.name, info.position, false)

	if (camera):
		setCamera(player)
		
func setCamera(player):
	var camera = Camera2D.new()
	player.add_child(camera)
	camera.make_current() 
	
func setUserType(newUserType):
	userType = newUserType