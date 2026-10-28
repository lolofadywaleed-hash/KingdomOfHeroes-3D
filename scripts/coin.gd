extends Area3D

var collected = false

func _ready():
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	if not collected:
		rotation.y += 2 * delta

func _on_body_entered(body):
	if collected:
		return
	if body.name == "Player":
		collected = true
		$Particles.emitting = true
		# Update HUD
		var hud = get_tree().get_first_node_in_group("hud")
		if hud and hud.has_method("add_coin"):
			hud.add_coin()
		await get_tree().create_timer(0.5).timeout
		queue_free()
