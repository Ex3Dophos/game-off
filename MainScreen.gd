extends Node

var ip = "127.0.0.1"
var userName = "Brian"

func _on_startGameButton_pressed():
	if userName == "":
		return
	Network.create_server(userName)
	get_tree().change_scene("res://dungeon.tscn")

func _on_joinGameButton_pressed():
	print("ip: " + ip + " user: " + userName)
	
	if userName == "":
		return
	Network.connect_to_server(userName)
	get_tree().change_scene("res://Game.tscn")

func _on_ipLineEdit_text_changed(new_text):
	ip = new_text


func _on_usernameLineEdit_text_changed(new_text):
	userName = new_text
