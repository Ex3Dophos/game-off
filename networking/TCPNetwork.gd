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

func create_server():
	var tcpServer = TCP_Server.new()
	tcpServer.listen(TCP_PORT)

