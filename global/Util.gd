extends Node

func showMainScreen():
	PlayerInformation.onCharacterSelection = false
	get_tree().change_scene('res://ui/main-screen/MainScreen.tscn')
	
func showCharacterSelectionScreen():
	PlayerInformation.onCharacterSelection = true
	get_tree().change_scene("res://ui/character-selection-screen/CharacterSelection.tscn")

func showGameScreen():
	PlayerInformation.onCharacterSelection = false
	get_tree().change_scene('res://Game.tscn')