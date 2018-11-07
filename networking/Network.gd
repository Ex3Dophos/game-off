extends Node

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = 31400
const MAX_PLAYERS = 5

var players = { }
var self_data = { name = '', position = Vector2(360, 180) }

var multiplayerServer

signal player_disconnected
signal server_disconnected

func _ready():
	get_tree().connect('network_peer_connected', self, 'playerConnectedToServer')
	get_tree().connect('network_peer_disconnected', self, 'playerDisconnectedFromServer')
	get_tree().connect('server_disconnected', self, 'serverConnectionLost')

func create_server(player_nickname):
	self_data.name = player_nickname
	players[1] = self_data
	multiplayerServer = NetworkedMultiplayerENet.new()
	multiplayerServer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(multiplayerServer)
	print("Server is listening on port: " + str(DEFAULT_PORT))

func connect_to_server(player_nickname, ip):
	self_data.name = player_nickname
	
	get_tree().connect('connected_to_server', self, 'connectionToServerSucceeded')
	get_tree().connect('connection_failed',self, 'connectionToServerFailed')
	
	multiplayerServer = NetworkedMultiplayerENet.new()
	multiplayerServer.create_client(ip, DEFAULT_PORT)
	
	get_tree().set_network_peer(multiplayerServer)

func connectionToServerSucceeded():
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = self_data
	rpc('_send_player_info', local_player_id, self_data)
	
func connectionToServerFailed():
	print("Could not connect to server.")
	get_tree().set_network_peer(null)
	Util.showMainScreen()
	
func playerConnectedToServer(connected_player_id):
	var local_player_id = get_tree().get_network_unique_id()
	if not(get_tree().is_network_server()):
		rpc_id(1, '_request_player_info', local_player_id, connected_player_id)
		
func playerDisconnectedFromServer(id):
	print("player: " + str(id) + " disconnected from the server.")
	$'/root/Game/dungeon/walls'.get_node(str(id)).queue_free()
	players.erase(id)
	
func serverConnectionLost():
	print("Lost connection to the server.")
	Util.showMainScreen()
	
func sendConnectedToOtherPlayers():
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = self_data
	
	rpc_id(int(self_data.name), "sendConnectionToOtherPlayers", local_player_id, PlayerInformation.userType, self_data)
	
func requestConnectedPlayerInformation():
	for peer_id in players:
		if( peer_id != get_tree().get_network_unique_id()):
			rpc_id(peer_id, 'sendCharacterType', int(self_data.name))
			
func disconnectFromServer():
	print("Disconnected from server.")
	multiplayerServer.close_connection()
	players.clear()
			
remote func sendConnectionToOtherPlayers(id, type, info):
	PlayerHandler.createPlayer(str(id), type, id, false)
	
remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])
		
remote func sendCharacterType(id):
	if not PlayerInformation.onCharacterSelection:
		rpc_id(id, "recieveCharacterType", get_tree().get_network_unique_id(), PlayerInformation.userType)
	
remote func recieveCharacterType(id, type):
	PlayerHandler.createPlayer(str(id), type, id, false)
	
remote func _send_player_info(id, info):
	players[id] = info
	