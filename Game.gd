extends Node

func _ready():
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('server_disconnected', self, '_on_server_disconnected')
	
	var new_player = preload('res://Player.tscn').instance()
	var new_dungeon = preload('res://dungeon.tscn').instance()
	
	add_child(new_dungeon)
	
	new_player.set_network_master(get_tree().get_network_unique_id())
	
	new_player.name = str(get_tree().get_network_unique_id())
	
	
	new_dungeon.get_node("walls").add_child(new_player)

	var info = Network.self_data
	new_player.init(info.name, info.position, false)
	new_player.get_node("usernameLabel").set_text(info.name)
	
	var camera = Camera2D.new()
	new_player.add_child(camera)
	camera.make_current() 
	
func _on_player_disconnected(id):
	get_node(str(id)).queue_free()
	
func _on_server_disconnected():
	get_tree().change_scene('res://MainScreen.tscn')