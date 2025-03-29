extends Node2D

@export var spawn_interval: float = 5.0  # Time in seconds between spawns

var berry_scenes = []  # To store paths to all berry scenes
@onready var spawnpoints = [$SpawnPoint1, $SpawnPoint2]  # Ensure these exist
@onready var timer = $Timer  # Ensure a Timer node exists inside Crate

func _ready():
	# Load berry scenes from the directory
	var berry_folder = "res://Scenes/Items/Berries/"
	var dir = DirAccess.open(berry_folder)

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):  # Only load scene files
				berry_scenes.append(berry_folder + file_name)
			file_name = dir.get_next()

	if berry_scenes.size() == 0:
		print("No berries found in folder!")

	# Start the spawn timer
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_berry)  # Connect the function
	timer.start()

func spawn_berry():
	if berry_scenes.size() == 0:
		print("No berries available to spawn!")
		return

	var berry_scene_path = berry_scenes[randi() % berry_scenes.size()]
	var berry_instance = load(berry_scene_path).instantiate()

	# Choose a random spawn point
	var spawn_point = spawnpoints[randi() % spawnpoints.size()]
	berry_instance.global_position = spawn_point.global_position

	# Add the berry to the game scene
	get_tree().get_root().get_node("Game").add_child(berry_instance)
	print("Spawned:", berry_scene_path, "at", spawn_point.name)
