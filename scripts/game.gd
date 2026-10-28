extends Node3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	var player = $Player
	if not player:
		return
	
	# Add gravity
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	
	# Handle jump
	var touch_controls = $TouchControls
	if touch_controls and touch_controls.jump_pressed and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY
	
	# Handle movement
	var input_dir = Vector2.ZERO
	# Keyboard input for testing
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1
	
	if input_dir != Vector2.ZERO:
		var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
	
	player.move_and_slide()
