extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.
enum MoveDirection { UP, DOWN, LEFT, RIGHT, NONE }
onready var TweenNode = get_node("Tween")

# Member variables
const MOTION_SPEED = 160 # Pixels/second
const SMOOTH_SPEED = 160
slave var slave_position = Vector2()
slave var slave_movement = MoveDirection.NONE


func init(nickname, start_position, is_slave):
	print("lol")
	#$GUI/Nickname.text = nickname
	#global_position = start_position
	if is_slave:
		$Sprite.texture = load('res://troll2.png')


func _input(event):
    if event is InputEventMouseButton:
        if event.pressed:
	        print("Mouse Click/Unclick at: ", event.position)
#            #var projectile = preload("res://projectile.tscn").instance()
#            #get_parent().add_child(projectile)
#            #projectile.shoot_at_mouse(self.global_position)
			
#	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
#		$Tween.interpolate_property($sprite, "transform/pos",$sprite.global_position, get_global_mouse_position(), 1,Tween.TRANS_LINEAR,Tween.EASE_IN)
#		$Tween.start()

			
func _physics_process(delta):
		
	var motion = Vector2()
	var mouse_position = get_global_mouse_position()
	
	var direction = MoveDirection.NONE#MoveDirection.NONE
	if is_network_master():
		if Input.is_action_pressed("move_up"):
			direction = MoveDirection.UP
		if Input.is_action_pressed("move_bottom"):
			direction = MoveDirection.DOWN
		if Input.is_action_pressed("move_left"):
			direction = MoveDirection.LEFT
		if Input.is_action_pressed("move_right"):
			direction = MoveDirection.RIGHT
	#	if Input.is_action_pressed("left_click"): #made an input map for left_click
	# 		motion = ( - position)
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			TweenNode.interpolate_property(self, "position",self.global_position, mouse_position, 1.0,Tween.TRANS_LINEAR,Tween.EASE_IN)
			TweenNode.start()
		
		
		
		
		#if Input.is_action_pressed('left'):
		#	direction = MoveDirection.LEFT
		#elif Input.is_action_pressed('right'):
		#	direction = MoveDirection.RIGHT
		#elif Input.is_action_pressed('up'):
	#		direction = MoveDirection.UP
#		elif Input.is_action_pressed('down'):
#			direction = MoveDirection.DOWN
		
		rset_unreliable('slave_position', position)
		rset('slave_movement', motion)
		_move(motion)
	else:
		_move(slave_movement)
		position = slave_position
	
	if get_tree().is_network_server():
		Network.update_position(int(name), position)
	
	
	
	
	
func _move(direction):
	match direction:
		MoveDirection.NONE:
			return
		MoveDirection.UP:
			move_and_collide(Vector2(0, -1))
		MoveDirection.DOWN:
			move_and_collide(Vector2(0, 1))
		MoveDirection.LEFT:
			move_and_collide(Vector2(-1, 0))
			#_rifle_left()
		MoveDirection.RIGHT:
			move_and_collide(Vector2(1, 0))
			#_rifle_right()

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
	

#	motion = motion.normalized(mouse_position) * MOTION_SPEED

#	move_and_slide(motion)
