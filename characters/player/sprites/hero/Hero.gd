extends "res://characters/player/Player.gd"

func init(nickname, start_position, is_slave):
	if !is_slave:
		inventory = preload('res://characters/player/ui/inventory/Inventory.tscn').instance()
		$'Sprite/Animation'.play('Stance W')
	#var usernameLabel = Label.new()
	#add_child(usernameLabel)

func _ready():
	pass
 
# add animation
func _animate(current_velocity, prev_velocity):
	var current_direction = direction2str(current_velocity)
	var animation = $'Sprite/Animation'
	var magnitude = sqrt(pow(current_velocity.x, 2) + pow(current_velocity.y, 2))
	is_moving = false if magnitude == 0 else true
	
	if is_moving:
		facing_direction = current_direction
		match current_direction:
			"right":  if animation.assigned_animation != "Running E" : animation.play('Running E')
			"down_right": if animation.assigned_animation != "Running SE" : animation.play('Running SE')
			"down": if animation.assigned_animation != "Running S" : animation.play('Running S')
			"down_left": if animation.assigned_animation != "Running SW" : animation.play('Running SW')
			"left": if animation.assigned_animation != "Running W" : animation.play('Running W')
			"up_left": if animation.assigned_animation != "Running NW" : animation.play('Running NW')
			"up": if animation.assigned_animation != "Running N" : animation.play('Running N')
			"up_right": if animation.assigned_animation != "Running NE" : animation.play('Running NE')
	else:
		match facing_direction:
			"right":  if animation.assigned_animation != "Stance E" : animation.play('Stance E')
			"down_right": if animation.assigned_animation != "Stance SE" : animation.play('Stance SE')
			"down": if animation.assigned_animation != "Stance S" : animation.play('Stance S')
			"down_left": if animation.assigned_animation != "Stance SW" : animation.play('Stance SW')
			"left": if animation.assigned_animation != "Stance W" : animation.play('Stance W')
			"up_left": if animation.assigned_animation != "Stance NW" : animation.play('Stance NW')
			"up": if animation.assigned_animation != "Stance N" : animation.play('Stance N')
			"up_right": if animation.assigned_animation != "Stance NE" : animation.play('Stance NE')
	pass
