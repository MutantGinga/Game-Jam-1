extends CharacterBody2D
class_name Player

## Gets the child of PrimaryAction node with index 0
@onready var primary_action: Node = $PrimaryAction.get_child(0)
## Gets the child of SecondaryAction node with index 0
@onready var secondary_action: Node = $SecondaryAction.get_child(0)
## Gets the child of DefensiveAction node with index 0
@onready var defensive_action: Node = $DefensiveAction.get_child(0)

@export var controller_look_deadzone: float = 0.3
@onready var game_manager = $"/root/GameManager"

## Runtime variable to denote if the last input was controller or MNK
var is_mnk: bool = true

# Check if the latest input event is mnk or controller
func _input(event):
	if (event is InputEventKey) or (event is InputEventMouseButton):
		is_mnk = true
	elif (event is InputEventJoypadButton) or (event is InputEventJoypadMotion):
		is_mnk = false

func _process(delta):
	_check_input()
	

func _physics_process(delta):
	_face_player()
	move_and_slide()

func _check_input():
	# Check if primary action is not null
	if primary_action:
		if Input.is_action_just_pressed("primary_action"): primary_action.use()
	# Check if secondary action is not null
	if secondary_action:
		if Input.is_action_just_pressed("secondary_action"): secondary_action.use()
	# Check if defensive action is not null
	if defensive_action:
		if Input.is_action_just_pressed("defensive_action"): defensive_action.use()
	## Added swap character buttons, tied to 1 and 2 number keys.
	if Input.is_action_just_pressed("select_character1"):
		game_manager.swap_character(0)
	if Input.is_action_just_pressed("select_character2"):
		game_manager.swap_character(1)
	
func _face_player():
	#check 
	if is_mnk:
		look_at(get_global_mouse_position())
	else:
		var look_direction = Vector2.ZERO
		look_direction.x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X) # Get right joystick x
		look_direction.y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y) # Get right joystick y
		# if outside the deadzone, rotate player 
		if look_direction.length() >= controller_look_deadzone:
			rotation = look_direction.angle()
