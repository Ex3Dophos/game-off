extends KinematicBody2D

# This is a demo showing how KinematicBody2D
# move_and_slide works.
var move_directions = ["right", "down_right", "down", "down_left", "left", "up_left", "up", "up_right"]
# Member variables
const MOTION_SPEED = 160 # Pixels/second

slave var slave_position = Vector2()
slave var slave_prev_position = Vector2()
slave var slave_prev_velocity = Vector2()

var destination = get_position()
var inventory = null
var prev_position = get_position()
var prev_velocity = Vector2()
var is_moving = false
var facing_direction = "down"

func init(nickname, start_position, is_slave):
	destination = start_position
	set_position(start_position)
	
	if !is_slave:
		inventory = preload('res://characters/player/ui/inventory/Inventory.tscn').instance()
		#$'Sprite/Animation'.play('Stance E')
	
func _input(event):
	if is_network_master():
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			destination = get_global_mouse_position()
			Network.sendMovement(get_global_mouse_position())
			PlayerInformation.setPlayerPosition(get_global_mouse_position())
		
		if Input.is_key_pressed(KEY_W):
			if has_node("PlayerInventory"):
				remove_child(inventory)
			else:
				add_child(inventory)
			
func movePlayer(position):
	destination = position
	
func _physics_process(delta):
	var velocity = Vector2()
	var player_position = get_position()
	
	var reposition = Vector2()
	reposition.x = destination.x - player_position.x
	reposition.y = destination.y - player_position.y

	var player_distance = player_position.distance_to(destination)
	if player_distance < 2.0:
		player_position = destination
	else:
		velocity = reposition
		
	var current_velocity = get_position() - prev_position
	
	_animate(current_velocity, prev_velocity)
	prev_position = get_position()
	prev_velocity = current_velocity
	_move(velocity)

func _animate(current_velocity, prev_velocity):
	pass

func direction2str(direction):
	var angle = direction.angle()
	if angle < 0:
		angle += 2 * PI
	var index = round(angle / PI * 4)
	if index > 7:
		index = int(index) % 8
	return move_directions[index]

func _move(direction):
	direction = direction.normalized() * MOTION_SPEED
	move_and_slide(direction)
	