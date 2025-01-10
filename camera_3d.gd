extends Camera3D

# Movement speed
@export var move_speed := 5.0

# Function to handle input for camera movement
func _process(delta):
	var movement = Vector3.ZERO

	# Capture WASD input and apply movement
	if Input.is_action_pressed("move_forward"):
		movement += transform.basis.y
	if Input.is_action_pressed("move_backward"):
		movement -= transform.basis.y
	if Input.is_action_pressed("move_left"):
		movement -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		movement += transform.basis.x

	# Normalize movement to prevent faster diagonal movement
	if movement != Vector3.ZERO:
		movement = movement.normalized() * move_speed * delta

	# Apply the movement
	global_transform.origin += movement
