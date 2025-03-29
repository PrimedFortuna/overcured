extends Node2D

var health: int = 100
var max_health: int = 100
var status: Array = []

func _ready():
	print("Pokemon Initialized: ", health, "HP")

func add_status(status_effect: String):
	status.append(status_effect)
	print("Status effect added: ", status_effect)

func remove_status(status_effect: String):
	if status_effect in status:
		status.erase(status_effect)
		print("Status effect removed: ", status_effect)
		
