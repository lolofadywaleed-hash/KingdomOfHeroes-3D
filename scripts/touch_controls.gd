extends CanvasLayer

var joystick_vector = Vector2.ZERO
var jump_pressed = false

func _ready():
	var jump_btn = $JumpButton
	if jump_btn:
		jump_btn.pressed.connect(_on_jump_pressed)
		jump_btn.button_up.connect(_on_jump_released)

func _on_jump_pressed():
	jump_pressed = true

func _on_jump_released():
	jump_pressed = false
