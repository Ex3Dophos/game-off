extends Node

func _on_startGameButton_pressed():
	if PlayerInformation.username == "":
		return
	Network.create_server(PlayerInformation.username)
	load_character_selection_screen()

func _on_joinGameButton_pressed():
	print("ip: " + ClientInformation.ip + " user: " + PlayerInformation.username)
	
	if PlayerInformation.username == "":
		return
		
	Network.connect_to_server(PlayerInformation.username, ClientInformation.ip)
	load_character_selection_screen()

func _on_ipLineEdit_text_changed(new_text):
	ClientInformation.setIP(new_text)

func _on_usernameLineEdit_text_changed(new_text):
	PlayerInformation.setUsername(new_text)

func load_character_selection_screen():
	get_tree().change_scene("res://ui/character-selection-screen/CharacterSelection.tscn")
	