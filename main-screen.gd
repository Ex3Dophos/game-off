extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
   # Mouse in viewport coordinates
   if event is InputEventMouseButton:
      get_tree().change_scene("res://dungeon.tscn")
      # print("Mouse Click/Unclick at: ", event.position)
   #elif event is InputEventMouseMotion:
       #print("Mouse Motion at: ", event.position)

   # Print the size of the viewport
   #print("Viewport Resolution is: ", get_viewport_rect().size)