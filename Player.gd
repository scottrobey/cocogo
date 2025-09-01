extends CharacterBody2D

# Movement parameters
@export var move_speed = 300.0
# actually jump height
@export var jump_velocity = -500.0
@export var dash_speed = 600.0
@export var dash_duration = 0.2
@export var gravity = 1800.0
@export var terminal_velocity = 1000.0

# Coyote time and jump buffering
@export var coyote_time = 0.15
@export var jump_buffer_time = 0.1

# control movement acceleration & deceleration
@export var acceleration = 1500.0
@export var friction = 1200.0
@export var air_resistance = 400.0

# Internal state
var dash_count = 0
var max_dashes = 1
var is_dashing = false
var dash_timer = 0.0
var coyote_timer = 0.0
var jump_buffer_timer = 0.0
var was_on_floor = false

# Input state
var move_input = 0.0
var jump_pressed = false
var dash_pressed = false

func _ready():
	print("Goal character ready!")

	# Initialize any starting values if needed
	pass

func _physics_process(delta):
	# Handle input
	handle_input()
	
	# Apply gravity
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, terminal_velocity)
	
	# Handle coyote time
	if is_on_floor():
		coyote_timer = coyote_time
		was_on_floor = true
		# Reset dash count when touching ground
		dash_count = 0
	else:
		coyote_timer -= delta
		if was_on_floor and coyote_timer <= 0:
			was_on_floor = false
	
	# Handle jump buffering
	if jump_pressed:
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta
	
	# Handle jumping
	if jump_buffer_timer > 0 and (is_on_floor() or coyote_timer > 0) and not is_dashing:
		velocity.y = jump_velocity
		jump_buffer_timer = 0
		coyote_timer = 0
	
	# Handle dashing
	if dash_pressed and dash_count < max_dashes and not is_on_floor() and not is_dashing:
		start_dash()
	
	# Update dash
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			end_dash()
	
	# Handle horizontal movement with acceleration/deceleration
	if not is_dashing:
		if move_input != 0:
			# Accelerate toward target speed
			var target_speed = move_input * move_speed
			velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
		else:
			# Apply friction when not moving
			var friction_force = friction if is_on_floor() else air_resistance
			velocity.x = move_toward(velocity.x, 0, friction_force * delta)

	# Move the character
	move_and_slide()

func handle_input():
	# Get input using only built-in actions
	move_input = Input.get_axis("ui_left", "ui_right")
	jump_pressed = Input.is_action_just_pressed("ui_accept")  # Spacebar
	dash_pressed = Input.is_action_just_pressed("ui_select")  # Shift

	# Debug prints
	if move_input != 0:
		print("Move input: ", move_input)
	if jump_pressed:
		print("Jump pressed!")

func start_dash():
	is_dashing = true
	dash_timer = dash_duration
	dash_count += 1
	
	# Set dash velocity based on facing direction
	var dash_direction = 1.0 if move_input >= 0 else -1.0
	if move_input == 0:
		# If not moving, dash in the direction the sprite is facing
		# For now, default to right
		dash_direction = 1.0
	
	velocity.x = dash_direction * dash_speed
	velocity.y = 0  # Stop vertical movement during dash

func end_dash():
	is_dashing = false
	# Reduce horizontal velocity after dash
	velocity.x *= 0.5
