extends Node3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	spawn_selected_hero()

func spawn_selected_hero():
	var hero_scene_path = ""
	match Global.selected_hero:
		"Hero1":
			hero_scene_path = "res://scenes/heroes/Lulu.tscn"
		"Hero2":
			hero_scene_path = "res://scenes/heroes/Fadi.tscn"
		"Hero3":
			hero_scene_path = "res://scenes/heroes/AlSayed.tscn"
		_:
			hero_scene_path = "res://scenes/heroes/Lulu.tscn"
	
	var hero_scene = load(hero_scene_path)
	if hero_scene:
		var hero_instance = hero_scene.instantiate()
		hero_instance.position = Vector3(0, 1, 0)
		add_child(hero_instance)
		# Replace player reference
		var old_player = $Player
		if old_player:
			old_player.queue_free()
		# Make camera follow new hero
		if hero_instance.has_node("SpringArm3D"):
			pass
		# Add spring arm and camera
		var spring_arm = SpringArm3D.new()
		spring_arm.spring_length = 5.0
		spring_arm.transform = Transform3D(1, 0, 0, 0, 0.866025, 0.5, 0, -0.5, 0.866025, 0, 2, 0)
		var camera = Camera3D.new()
		camera.current = true
		camera.transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 5)
		spring_arm.add_child(camera)
		hero_instance.add_child(spring_arm)
		hero_instance.name = "Player"

func _physics_process(delta):
	var player = get_node_or_null("Player")
	if not player:
		return
	
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	
	var touch_controls = $TouchControls
	if touch_controls and touch_controls.jump_pressed and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY
	
	var input_dir = Vector2.ZERO
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
