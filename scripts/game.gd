extends Node3D

var player: CharacterBody3D
var coin_count := 0
var joystick_touch := -1
var joystick_origin := Vector2.ZERO
var joystick_value := Vector2.ZERO
var jump_action: Callable

func _ready() -> void:
	_build_world()
	var hero := str(get_tree().get_meta("selected_hero", "lulu"))
	var ps := load("res://scenes/heroes/" + hero + ".tscn") as PackedScene
	player = ps.instantiate()
	player.position = Vector3(0, 0, 2)
	add_child(player)
	_build_hud()
	_build_coins()

func _build_world() -> void:
	var env_node := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var sky_mat := ProceduralSkyMaterial.new()
	sky_mat.sky_top_color = Color("18284b")
	sky_mat.sky_horizon_color = Color("f0a16c")
	sky_mat.ground_bottom_color = Color("172334")
	sky_mat.ground_horizon_color = Color("d18358")
	sky.sky_material = sky_mat
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("9aaddb")
	env.ambient_light_energy = 0.55
	env_node.environment = env
	add_child(env_node)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48, -28, 0)
	sun.light_color = Color("ffd5a1")
	sun.light_energy = 1.15
	add_child(sun)
	var ground := StaticBody3D.new()
	var floor_mesh := MeshInstance3D.new()
	var plane := PlaneMesh.new()
	plane.size = Vector2(45, 45)
	floor_mesh.mesh = plane
	var grass := StandardMaterial3D.new()
	grass.albedo_color = Color("315b45")
	grass.roughness = 1.0
	floor_mesh.material_override = grass
	ground.add_child(floor_mesh)
	var cs := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(45, 0.3, 45)
	cs.shape = shape
	cs.position.y = -0.16
	ground.add_child(cs)
	add_child(ground)
	for i in range(5): _make_tree(Vector3(-9 + i * 4.5, 0, -7 - (i % 2) * 3))
	for i in range(3): _make_rock(Vector3(-6 + i * 6, 0, 4 - (i % 2) * 2))
	var magic := OmniLight3D.new()
	magic.position = Vector3(0, 3, -2)
	magic.light_color = Color("69c8ff")
	magic.light_energy = 1.2
	magic.omni_range = 9
	add_child(magic)

func _make_tree(at: Vector3) -> void:
	var trunk := MeshInstance3D.new()
	var cylinder := CylinderMesh.new()
	cylinder.top_radius = 0.28
	cylinder.bottom_radius = 0.42
	cylinder.height = 2.6
	trunk.mesh = cylinder
	trunk.position = at + Vector3(0, 1.3, 0)
	var bark := StandardMaterial3D.new(); bark.albedo_color = Color("684b3a"); trunk.material_override = bark; add_child(trunk)
	var leaves := MeshInstance3D.new()
	var crown := SphereMesh.new(); crown.radius = 1.45; crown.height = 2.5; leaves.mesh = crown
	leaves.position = at + Vector3(0, 3.0, 0)
	var green := StandardMaterial3D.new(); green.albedo_color = Color("267653"); green.roughness = 0.8; leaves.material_override = green; add_child(leaves)

func _make_rock(at: Vector3) -> void:
	var rock := MeshInstance3D.new(); var mesh := SphereMesh.new(); mesh.radius = 0.8; mesh.height = 1.1; rock.mesh = mesh
	rock.scale = Vector3(1.2, 0.7, 0.9); rock.position = at + Vector3(0, 0.4, 0)
	var mat := StandardMaterial3D.new(); mat.albedo_color = Color("68717c"); rock.material_override = mat; add_child(rock)

func _build_hud() -> void:
	var layer := CanvasLayer.new(); layer.name = "HUD"; add_child(layer)
	var label := Label.new(); label.name = "Coins"; label.text = "● 0"; label.position = Vector2(1080, 28); label.add_theme_font_size_override("font_size", 30); label.add_theme_color_override("font_color", Color("ffd45e")); layer.add_child(label)
	var hearts := Label.new(); hearts.text = "♥  ♥  ♥"; hearts.position = Vector2(26, 24); hearts.add_theme_font_size_override("font_size", 30); hearts.add_theme_color_override("font_color", Color("ff6478")); layer.add_child(hearts)
	var stick := Control.new(); stick.name = "Joystick"; stick.position = Vector2(35, 470); stick.size = Vector2(190, 190); stick.mouse_filter = Control.MOUSE_FILTER_STOP; layer.add_child(stick)
	var pad := ColorRect.new(); pad.position = Vector2(12, 12); pad.size = Vector2(166, 166); pad.color = Color(0.7, 0.8, 1, 0.18); stick.add_child(pad)
	var knob := ColorRect.new(); knob.name = "Knob"; knob.position = Vector2(61, 61); knob.size = Vector2(68, 68); knob.color = Color(0.85, 0.9, 1, 0.5); stick.add_child(knob)
	var jump := Button.new(); jump.name = "Jump"; jump.text = "قفز"; jump.position = Vector2(1080, 565); jump.size = Vector2(150, 105); jump.add_theme_font_size_override("font_size", 26); layer.add_child(jump)
	jump.pressed.connect(func(): player.velocity.y = 6.0)
	var skill := Button.new(); skill.text = "مهارة"; skill.position = Vector2(1100, 445); skill.size = Vector2(120, 80); skill.add_theme_font_size_override("font_size", 22); layer.add_child(skill)
	stick.gui_input.connect(_on_joystick_input.bind(stick, knob))

func _on_joystick_input(event: InputEvent, stick: Control, knob: Control) -> void:
	if event is InputEventScreenTouch:
		if event.pressed: joystick_touch = event.index
		else: joystick_touch = -1; joystick_value = Vector2.ZERO
	elif event is InputEventScreenDrag and (joystick_touch == -1 or event.index == joystick_touch):
		var delta := (event.position - stick.global_position - stick.size / 2.0).limit_length(60)
		joystick_value = Vector2(delta.x / 60.0, delta.y / 60.0)
		knob.position = stick.size / 2.0 - knob.size / 2.0 + delta
	player.move_input = joystick_value

func _build_coins() -> void:
	for i in range(15):
		var coin := Area3D.new(); coin.name = "Coin" + str(i); coin.position = Vector3(-7 + (i % 5) * 3.5, 1.0, -4 + int(i / 5) * 4)
		var mesh := MeshInstance3D.new(); var cyl := CylinderMesh.new(); cyl.top_radius = 0.38; cyl.bottom_radius = 0.38; cyl.height = 0.12; mesh.mesh = cyl; mesh.rotation_degrees.x = 90
		var gold := StandardMaterial3D.new(); gold.albedo_color = Color("ffd34f"); gold.metallic = 0.65; mesh.material_override = gold; coin.add_child(mesh)
		var collision := CollisionShape3D.new(); var sphere := SphereShape3D.new(); sphere.radius = 0.65; collision.shape = sphere; coin.add_child(collision)
		coin.body_entered.connect(_on_coin_collected.bind(coin)); add_child(coin)

func _on_coin_collected(body: Node3D, coin: Area3D) -> void:
	if body == player:
		coin_count += 1
		get_node("HUD/Coins").text = "● " + str(coin_count)
		coin.queue_free()

func _process(delta: float) -> void:
	for coin in get_tree().get_nodes_in_group("coins"):
		coin.rotate_y(delta * 2.5)
	for coin in get_children():
		if coin is Area3D and coin.name.begins_with("Coin"): coin.rotate_y(delta * 2.5)
