extends CharacterBody3D

@export var hero_id := "lulu"
var move_input := Vector2.ZERO
var speed := 5.0
var jump_velocity := 6.0
var gravity := 18.0
var hero_color := Color("58d68d")
var camera_pivot: Node3D

func _ready() -> void:
	match hero_id:
		"fadi": hero_color = Color("f06454")
		"alsayed": hero_color = Color("55b8ee")
	var body := MeshInstance3D.new()
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.48
	capsule.height = 1.8
	body.mesh = capsule
	var mat := StandardMaterial3D.new()
	mat.albedo_color = hero_color
	mat.roughness = 0.42
	body.material_override = mat
	body.position.y = 1.0
	add_child(body)
	var aura := MeshInstance3D.new()
	var aura_mesh := SphereMesh.new()
	aura_mesh.radius = 0.72
	aura_mesh.height = 1.8
	aura.mesh = aura_mesh
	var aura_mat := StandardMaterial3D.new()
	aura_mat.albedo_color = Color(hero_color, 0.16)
	aura_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	aura_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	aura.material_override = aura_mat
	aura.position.y = 1.0
	add_child(aura)
	var collider := CollisionShape3D.new()
	var shape := CapsuleShape3D.new()
	shape.radius = 0.42
	shape.height = 1.7
	collider.shape = shape
	collider.position.y = 0.9
	add_child(collider)
	camera_pivot = Node3D.new()
	camera_pivot.position.y = 1.2
	add_child(camera_pivot)
	var arm := SpringArm3D.new()
	arm.spring_length = 6.0
	arm.rotation.x = deg_to_rad(-15)
	camera_pivot.add_child(arm)
	var camera := Camera3D.new()
	camera.current = true
	arm.add_child(camera)

func _physics_process(delta: float) -> void:
	if not is_on_floor(): velocity.y -= gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor(): velocity.y = jump_velocity
	var input := move_input
	if input.length() < 0.05:
		input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input.x, 0, input.y)
	if direction.length() > 1.0: direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	if direction.length() > 0.1: rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), 10.0 * delta)
	move_and_slide()
