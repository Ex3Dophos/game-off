#extends Tween
#
#onready var TweenNode = get_node("Tween")
## class member variables go here, for example:
## var a = 2
## var b = "textvar"
#
#func _ready():
#	# Called when the node is added to the scene for the first time.
#	# Initialization here
#	pass
#
#func _process(delta):
#	var mouse_position = get_global_mouse_position()
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	if Input.is_mouse_button_pressed(BUTTON_LEFT):
#		TweenNode.interpolate_property(self, "transform/pos",self.global_position, mouse_position, 1.0,Tween.TRANS_LINEAR,Tween.EASE_IN)
#		TweenNode.start()
#		pass
