extends CharacterBody3D


# Movement speed and tile size
var tile_size := 1.0
var move_direction := Vector3.ZERO
var is_moving := false

func _input(event):
	if event is InputEventKey and event.pressed and not is_moving:
		if event.keycode == KEY_UP:
			move_direction = Vector3(0, 0, -tile_size)
		elif event.keycode == KEY_DOWN:
			move_direction = Vector3(0, 0, tile_size)
		elif event.keycode == KEY_LEFT:
			move_direction = Vector3(-tile_size, 0, 0)
		elif event.keycode == KEY_RIGHT:
			move_direction = Vector3(tile_size, 0, 0)
		
		if move_direction != Vector3.ZERO:
			move_player()

func move_player():
	is_moving = true
	
	# Check for collision
	var collision = move_and_collide(move_direction, true)

	if collision != null:
		# If collision is with a box, try to push it
		if collision.get_collider() is RigidBody3D:
			var box = collision.get_collider()
			var box_position_after_push = box.global_transform.origin + move_direction
			# Check if there's space behind the box before moving it
			if not check_collision(box_position_after_push):
				box.global_transform.origin += move_direction
				global_transform.origin += move_direction
				#print("Box pushed!")
			else:
				print("Blocked! Can't push box.")
		else:
			print("Collision detected with:", collision.get_collider().name)
	else:
		# No collision, move the player
		global_transform.origin += move_direction
	# Delay to prevent continuous movement
	await get_tree().create_timer(0.2).timeout
	is_moving = false
	
func check_collision(position):
	# Cast a ray to check if there's an object in the given position
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_transform.origin + move_direction * 1.5, position)
	var result = space_state.intersect_ray(query)
	return result.size() > 0  # True if something was hit
