extends Area2D

var lose_label = null

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		print("Player hit spike!")
		show_lose_message()

func _input(event):
	# Handle input even when paused - any key restarts
	if lose_label != null and event.is_action_pressed("ui_accept"):  # Spacebar
		restart_game()

func show_lose_message():
	print("YOU TOUCHED THE BROCCOLI! EWWWWW")
	
	# Create the lose message
	lose_label = Label.new()
	lose_label.text = "YOU TOUCHED THE BROCCOLI! EWWWWW\nPress spacebar to restart"
	lose_label.add_theme_font_size_override("font_size", 35)
	lose_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lose_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lose_label.size = Vector2(400, 200)
	
	# Center on current camera view
	var camera = get_viewport().get_camera_2d()
	if camera:
		lose_label.global_position = camera.global_position + Vector2(-200, -100)
	else:
		var viewport_size = get_viewport().get_visible_rect().size
		lose_label.position = Vector2(viewport_size.x/2 - 200, viewport_size.y/2 - 100)
	
	# Add to scene
	get_tree().current_scene.add_child(lose_label)
	
	# Set process mode to handle input while paused
	lose_label.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Pause the game
	get_tree().paused = true

func restart_game():
	# Unpause and restart
	get_tree().paused = false
	get_tree().reload_current_scene()
