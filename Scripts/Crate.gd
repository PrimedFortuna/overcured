extends Node2D

@export var spawn_interval: float = 15.0  # Time in seconds between spawns

var berry_scenes = []  # To store paths to all berry scenes
@onready var spawnpoints = [$SpawnPoint1, $SpawnPoint2]  # Ensure these exist
@onready var timer = $Timer  # Ensure a Timer node exists inside Crate
@onready var berries_container = $BerriesContainer  # Holds the spawned berries

func _ready():
	# Load berry scenes from the directory
	var berry_folder = "res://Scenes/Items/Raw/"
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
	timer.timeout.connect(spawn_berry)
	timer.start()

func spawn_berry():
	# Stop spawning if both spawn points are occupied
	if berries_container.get_child_count() >= 2:
		print("Both spawn points occupied, skipping spawn.")
		return

	if berry_scenes.size() == 0:
		print("No berries available to spawn!")
		return

	# Load a random berry scene
	var berry_scene_path = berry_scenes[randi() % berry_scenes.size()]
	var berry_instance = load(berry_scene_path).instantiate()

	# Pick the correct spawn point (first free spot)
	var spawn_point = spawnpoints[berries_container.get_child_count()]
	berry_instance.position = spawn_point.position  # Local position inside the crate

	# Add the berry to the crate's container
	berries_container.add_child(berry_instance)
	print("Spawned:", berry_scene_path, "at", spawn_point.name)
