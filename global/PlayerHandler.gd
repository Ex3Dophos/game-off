extends Node

var username = ""
var userType = ""

func createPlayer(playerName, type, id, camera):
	
	var player
	
	if type == 1:
		player = load('res://characters/player/sprites/hero/Hero.tscn').instance()
#		$Sprite.texture = load('res://characters/player/sprites/troll.png')
	if type == 2:
		player = load('res://characters/player/sprites/skeleton/Skeleton.tscn').instance()
#		$Sprite.texture = load('res://characters/player/sprites/troll2.png')
	
	
	player.set_network_master(id)
	player.name = playerName
	
	$'/root/Game/dungeon/walls'.add_child(player)
	
	var info = Network.self_data
	player.init(info.name, info.position, false)
#	player.get_node("usernameLabel").set_text(info.name)
	
	if (camera):
		setCamera(player)
	
func setCamera(player):
	var camera = Camera2D.new()
	player.add_child(camera)
	camera.make_current() 
	
func setUserType(newUserType):
	userType = newUserType