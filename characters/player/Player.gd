extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.
enum MoveDirection { UP, DOWN, LEFT, RIGHT, NONE }

# Member variables
const MOTION_SPEED = 160 # Pixels/second

slave var slave_position = Vector2()
slave var slave_movement = MoveDirection.NONE

var destination = get_position()
var inventory = null



func init(nickname, start_position, is_slave):
	if is_slave:
		$Sprite.texture = load('res://characters/player/sprites/troll2.png')
	else:
		inventory = preload('res://characters/player/ui/inventory/Inventory.tscn').instance()
		var hero = preload('res://characters/player/sprites/hero/Hero.tscn').instance()
		add_child(hero)
		$Sprite.texture = get_node('Hero')
		get_node('Hero').get_node('Animation').play('Stance W')


func _input(event):
	if is_network_master():
		if Input.is_key_pressed(KEY_W):
			if has_node("PlayerInventory"):
				remove_child(inventory)	
			else:
				add_child(inventory)
			

func _physics_process(delta):

	var velocity = Vector2()
	var mouse_position = get_global_mouse_position()
	var player_position = get_position()

#       var mbposition = get("position")
	var reposition = Vector2()
	reposition.x = destination.x - player_position.x
	reposition.y = destination.y - player_position.y

	var direction = MoveDirection.NONE#MoveDirection.NONE
	if is_network_master():
#		if int(round(reposition.x)) != 0 || int(round(reposition.y)) != 0:
#            print ("position ", position)
#            print ("destination ", destination)
#            print ("reposition ", reposition)
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			destination = mouse_position

		var player_distance = player_position.distance_to(destination)
		if player_distance < 2.0:
			player_position = destination
		else:
			velocity = reposition
#		if player_position != get_position():
#			set_position(player_position.linear_interpolate(destination,delta))

		rset_unreliable('slave_position', position)
		rset('slave_movement', velocity)
		_move(velocity)
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
	direction = direction.normalized() * MOTION_SPEED
	move_and_slide(direction)
