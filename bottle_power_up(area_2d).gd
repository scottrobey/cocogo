extends Area2D

func _ready():
	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		print("Jump power-up collected!")
		# Increase player's jump power by 40%
		body.jump_velocity *= 1.4  # 40% increase (negative values, so multiply by 1.4)
		print("New jump velocity: ", body.jump_velocity)
		
		# Show the "mmmm" effect
		show_collection_effect()
		
		# Make the power-up disappear
		queue_free()

func show_collection_effect():
	# Create the "mmmm" text
	var effect_label = Label.new()
	effect_label.text = "mmmm. I can jump higher now!!"
	effect_label.add_theme_font_size_override("font_size", 32)
	effect_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	effect_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Position it where the power-up was
	effect_label.global_position = global_position + Vector2(-30, -50)  # Slightly above the power-up
	effect_label.size = Vector2(60, 40)
	
	# Add to scene
	get_tree().current_scene.add_child(effect_label)
	
	# Make it disappear after 3 seconds
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.timeout.connect(func(): effect_label.queue_free())
	effect_label.add_child(timer)
	timer.start()
