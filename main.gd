extends Node3D

# Load tile scenes (drag these into the inspector)
@export var wall_scene: PackedScene
@export var box_scene: PackedScene
@export var player_scene: PackedScene
@export var target_scene: PackedScene
@export var grass_scene: PackedScene
@export var floor_scene: PackedScene

func _ready():
	load_level("res://Assets/Levels/l-1.txt")
	print("hellllllooooooo2")

func load_level(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Error: Cannot open level file!")
		return

	var y_position = 0  # To track rows

	# Loop through each line (each row of the level)
	while not file.eof_reached():
		var line = file.get_line()
		for x_position in range(line.length()):
			var char = line[x_position]
			var position = Vector3(x_position, 0.5, y_position)  # 3D grid position
			var Planeposition = Vector3(x_position, 0, y_position)  # 3D grid position
			spawn_tile(floor_scene, Planeposition)
			
			match char:
				'W' : spawn_tile(wall_scene, position)
				'S' : spawn_tile(player_scene, position)
				'X' : spawn_tile(box_scene, position)
				'o' : spawn_tile(target_scene, Planeposition)
				' ' : spawn_tile(floor_scene, Planeposition)
				'+' : spawn_tile(grass_scene, Planeposition)
		y_position += 1

func spawn_tile(scene: PackedScene, position: Vector3):
	# Instantiate the tile
	var tile_instance = scene.instantiate()

	# ✅ Add the tile to the scene first, THEN set the position
	add_child(tile_instance)
	print("hellllllo")
	# ✅ Set position only after the tile is added to the tree
	tile_instance.global_transform.origin = position
