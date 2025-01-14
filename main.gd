extends Node3D

# Load tile scenes (drag these into the inspector)
@export var wall_scene: PackedScene
@export var box_scene: PackedScene
@export var player_scene: PackedScene
@export var target_scene: PackedScene
@export var grass_scene: PackedScene
@export var floor_scene: PackedScene

var boxes_on_targets := 0
var total_targets := 0
var levels_completed := 0
var level_paths := [
	"res://Assets/Levels/l-1.txt",
	"res://Assets/Levels/l-2.txt",
	"res://Assets/Levels/l-3.txt"
]


func _ready():
	load_level(level_paths[levels_completed])
	connect_signals()


func connect_signals():
	for child in get_children():
		if child is Area3D :
			child.box_entered.connect(on_box_placed)
			child.box_exited.connect(on_box_removed)



func on_box_removed():
	boxes_on_targets -= 1
	#print("Box removed! Current boxes on targets:", boxes_on_targets)


func on_box_placed():
	boxes_on_targets += 1
	#print("Box placed! Current boxes on targets:", boxes_on_targets)
	check_win_condition()



func check_win_condition():
	if boxes_on_targets == total_targets:
		print("Level Complete!")
		#await get_tree().create_timer(1).timeout
		levels_completed+=1
		
		if levels_completed<level_paths.size():
			clear_level()
			print("Loading next level...")
			load_level(level_paths[levels_completed])
			connect_signals()
		else:
			print("Game over, all levels completed!")
			

func clear_level():
	print("Clearing current level...")
	# Loop through children and remove dynamically added ones
	for child in get_children():
		# Only remove dynamically added objects (excluding the LevelManager itself)
		if child != self:
			child.queue_free()  # Marks nodes for deletion safely
	await get_tree().process_frame  # Wait for nodes to be freed before continuing
	print("Level cleared!")


func load_level(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Error: Cannot open level file!")
		return

	var y_position = 0  # To track rows
	total_targets = 0

	# Loop through each line (each row of the level)
	while not file.eof_reached():
		var line = file.get_line()
		for x_position in range(line.length()):
			var char = line[x_position]
			var position = Vector3(x_position, 0.5, y_position)  # 3D grid position
			var Planeposition = Vector3(x_position, 0, y_position)  # 3D grid position
			spawn_tile(floor_scene, Planeposition)
			if char == "o":
				total_targets+=1
			
			match char:
				'W' : spawn_tile(wall_scene, position)
				'S' : spawn_tile(player_scene, position)
				'X' : spawn_tile(box_scene, position)
				'o' : spawn_tile(target_scene, Planeposition)
				' ' : spawn_tile(floor_scene, Planeposition)
				'+' : spawn_tile(grass_scene, Planeposition)
		y_position += 1
	print_tree()
	print("Total Targets: ", total_targets)


func spawn_tile(scene: PackedScene, position: Vector3):
	# Instantiate the tile
	var tile_instance = scene.instantiate()
	add_child(tile_instance)
	tile_instance.name = tile_instance.get_class() + "_" + str(position)
	tile_instance.global_transform.origin = position
