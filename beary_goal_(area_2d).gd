extends Area2D

var win_label = null

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		show_win_message()

func _input(event):
	# Handle input even when paused - only spacebar restarts
	if win_label != null and event.is_action_pressed("ui_accept"):  # Spacebar
		restart_game()

func show_win_message():
	print("YOU SAVED YOUR BUBBA CHOU!!!! YAY!!!!")
	
	# Get viewport size to center the message
	var viewport = get_viewport()
	var viewport_size = viewport.get_visible_rect().size
	
	# Create the win message
	win_label = Label.new()
	win_label.text = "YOU SAVED YOUR BUBBA CHOU!!!! YAY!!!!\nPress spacebar to restart"
	win_label.add_theme_font_size_override("font_size", 35)
	win_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	win_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	win_label.size = Vector2(400, 200)
	
	# Center on current camera view
	var camera = get_viewport().get_camera_2d()
	if camera:
		win_label.global_position = camera.global_position + Vector2(-200, -100)
	else:
		win_label.position = Vector2(viewport_size.x/2 - 200, viewport_size.y/2 - 100)
	
	# Add to scene
	get_tree().current_scene.add_child(win_label)
	
	# Set process mode to handle input while paused
	win_label.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Pause the game
	get_tree().paused = true

func restart_game():
	# Unpause and restart
	get_tree().paused = false
	get_tree().reload_current_scene()
