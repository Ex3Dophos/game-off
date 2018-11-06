extends Node

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = 31400
const TCP_PORT = 31500
const MAX_PLAYERS = 5

var players = { }
var self_data = { name = '', position = Vector2(360, 180) }

signal player_disconnected
signal server_disconnected

func _ready():
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('network_peer_connected', self, '_on_player_connected')

func create_server(player_nickname):
	self_data.name = player_nickname
	players[1] = self_data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	print("Server is listening on port: " + str(DEFAULT_PORT))

func connect_to_server(player_nickname, ip):
	self_data.name = player_nickname
	
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	get_tree().connect('connection_failed',self, '_connected_fail')
	
	var peer = NetworkedMultiplayerENet.new()
	var peerid = peer.create_client(ip, DEFAULT_PORT)
	
	get_tree().set_network_peer(peer)

func _connected_to_server():
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = self_data
	rpc('_send_player_info', local_player_id, self_data)

func _on_player_disconnected(id):
	players.erase(id)

func _on_player_connected(connected_player_id):
	var local_player_id = get_tree().get_network_unique_id()
	if not(get_tree().is_network_server()):
		rpc_id(1, '_request_player_info', local_player_id, connected_player_id)
		
func sendConnectedToOtherPlayers(connected_player_id):
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = self_data
	
	rpc_id(connected_player_id, "sendConnectionToOtherPlayers", local_player_id, PlayerInformation.userType, self_data)
	
remote func sendConnectionToOtherPlayers(id, type, info):
	PlayerHandler.createPlayer(str(id), type, id, false)
	
remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])

func _request_players(request_from_id):
	for peer_id in players:
		if( peer_id != get_tree().get_network_unique_id()):
			PlayerHandler.createPlayer(str(peer_id), PlayerInformation.userType, peer_id, false)
			#rpc_id(request_from_id, '_send_player_info', peer_id, players[peer_id])

remote func _send_player_info(id, info):
	players[id] = info

func update_position(id, position):
	players[id].position = position
	
func _connected_fail():
	get_tree().set_network_peer(null)
	get_tree().change_scene('res://ui/main-screen/MainScreen.tscn')
	