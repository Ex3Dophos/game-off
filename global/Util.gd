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
	
func getallnodes(node):
    for N in node.get_children():
        if N.get_child_count() > 0:
            print("["+N.get_name()+"]")
            getallnodes(N)
        else:
            print("- "+N.get_name())
			
func getIndexOfItemFromNode(node, item):
	var i = 0
	for N in node.get_children():
		if N.get_name() == item:
			return int(i)
		i = i + 1