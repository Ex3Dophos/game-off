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
	get_tree().connect('connected_to_server', self, 'connectionToServerSucceeded')
	get_tree().connect('connection_failed',self, 'connectionToServerFailed')

func create_server(player_nickname):
	self_data.name = player_nickname
	players[1] = self_data
	
	multiplayerServer = NetworkedMultiplayerENet.new()
	multiplayerServer.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(multiplayerServer)
	
	print("Server is listening on port: " + str(DEFAULT_PORT))

func connect_to_server(player_nickname, ip):
	self_data.name = player_nickname
	
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
	
	rpc_id(int(self_data.name), "sendConnectionToOtherPlayers", local_player_id, PlayerInformation.userType, PlayerInformation.position, self_data)
	
func requestConnectedPlayerInformation():
	for peer_id in players:
		if( peer_id != get_tree().get_network_unique_id()):
			rpc_id(peer_id, 'sendCharacterDetails', int(self_data.name))
			
func disconnectFromServer():
	print("Disconnected from server.")
	multiplayerServer.close_connection()
	players.clear()

func sendMovement(mousePosition):
	for peer_id in players:
		if( peer_id != get_tree().get_network_unique_id()):
			rpc_id(peer_id, "recieveMousePosition", get_tree().get_network_unique_id(), mousePosition)
	
remote func recieveMousePosition(id, mousePosition):
		if not PlayerInformation.onCharacterSelection:
			$'/root/Game/dungeon/walls'.get_child(Util.getIndexOfItemFromNode($'/root/Game/dungeon/walls', str(id))).movePlayer(mousePosition)
			
remote func sendConnectionToOtherPlayers(id, type, position, info):
	PlayerHandler.createPlayer(str(id), type, id, position, false)
	
remote func _request_player_info(request_from_id, player_id):
	if get_tree().is_network_server():
		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])
		
remote func sendCharacterDetails(id):
	if not PlayerInformation.onCharacterSelection:
		rpc_id(id, "recieveCharacterDetails", get_tree().get_network_unique_id(), PlayerInformation.userType, PlayerInformation.position)
	
remote func recieveCharacterDetails(id, type, position):
	PlayerHandler.createPlayer(str(id), type, id, position, false)
	
remote func _send_player_info(id, info):
	players[id] = info
	