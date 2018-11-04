extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.

onready var TweenNode = get_node("Tween")

# Member variables
const MOTION_SPEED = 160 # Pixels/second
const SMOOTH_SPEED = 160



func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("Mouse Click/Unclick at: ", event.position)
	if Input.is_key_pressed(KEY_W):
		get_tree().change_scene("res://Inventory.tscn")

			
func _physics_process(delta):
	var motion = Vector2()
	var mouse_position = get_global_mouse_position()
#	var mbposition = get("position")
	
#	var repos = Vector2()
#	var repos_velo = Vector2()
#	var position = Vector2()
#
#	var mpos = get_viewport().get_mouse_position()#.get_mouse_pos()
#	var destination = get_position()
#	repos.x = mpos.x - destination.x
#	repos.y = mpos.y - destination.y
#	repos_velo.x = repos.x * SMOOTH_SPEED * delta
#	repos_velo.y = repos.y * SMOOTH_SPEED * delta
#
#	position.x += repos_velo.x
#	position.y += repos_velo.y
#
#	move_and_slide(repos_velo)
	
	if Input.is_action_pressed("move_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed("move_bottom"):
		motion += Vector2(0, 1)
	if Input.is_action_pressed("move_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed("move_right"):
		motion += Vector2(1, 0)
#	if Input.is_action_pressed("left_click"): #made an input map for left_click
# 		motion = ( - position)
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		TweenNode.interpolate_property(self, "position",self.global_position, mouse_position, 1.0,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
#	motion = motion.normalized(mouse_position) * MOTION_SPEED

#	move_and_slide(motion)
