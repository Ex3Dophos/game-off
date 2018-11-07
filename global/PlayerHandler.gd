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
	#player
	#player.get_parent().get_child("usernameLabel").set_text(info.name)
	getallnodes(player)#player)
	#print(player.get_parent())
	#player.get_parent(
	
	if (camera):
		setCamera(player)
		
func getallnodes(node):
    for N in node.get_children():
        if N.get_child_count() > 0:
            print("["+N.get_name()+"]")
            getallnodes(N)
        else:
            # Do something
            print("- "+N.get_name())

func setCamera(player):
	var camera = Camera2D.new()
	player.add_child(camera)
	camera.make_current() 
	
func setUserType(newUserType):
	userType = newUserType