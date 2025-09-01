extends Area2D

var fall_label = null

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		print("Player fell!")
		# Wait 1 second, then show message
		await get_tree().create_timer(1.0).timeout
		show_fall_message()

func _input(event):
	# Handle input even when paused - only spacebar restarts
	if fall_label != null and event.is_action_pressed("ui_accept"):  # Spacebar
		restart_game()

func show_fall_message():
	print("YOU FELL!")
	
	# Create the fall message
	fall_label = Label.new()
	fall_label.text = "Uh Oh! You fell!\nPress SPACEBAR to restart"
	fall_label.add_theme_font_size_override("font_size", 48)
	fall_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	fall_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	fall_label.size = Vector2(400, 200)
	
	# Center on current camera view
	var camera = get_viewport().get_camera_2d()
	if camera:
		fall_label.global_position = camera.global_position + Vector2(-200, -100)
	
	# Add to scene
	get_tree().current_scene.add_child(fall_label)
	
	# Set process mode to handle input while paused
	fall_label.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Pause the game
	get_tree().paused = true

func restart_game():
	# Unpause and restart
	get_tree().paused = false
	get_tree().reload_current_scene()
