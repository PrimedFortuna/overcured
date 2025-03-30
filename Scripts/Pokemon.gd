extends Node2D

var health: int = 100
var max_health: int = 100
var status: Array = []
var completed: bool = false

var possible_status_effects: Array = ["Poisoned", "Burned", "Paralyzed", "Asleep", "Frozen"]

func _ready():
	add_to_group("pokemon")
	health = randi_range(10, max_health)
	print("Pokemon Initialized: ", health, "HP")
	var random_status = possible_status_effects[randi() % possible_status_effects.size()]
	add_status(random_status)
	check_if_completed()

func add_status(status_effect: String):
	status.append(status_effect)
	print("Status effect added: ", status_effect)

func remove_status(status_effect: String):
	if status_effect in status:
		status.erase(status_effect)
		print("Status effect removed: ", status_effect)
	check_if_completed()
	
func heal(value: int):
	if health < max_health:
		health += value
		if health > max_health:
			health = max_health
		print("Healed to: ", health, "out of", max_health)
	check_if_completed()


func check_if_completed():
	if health == max_health and status.size() == 0:
		completed = true
		print("Pokemon is completed!")
	else:
		completed = false
		print("Pokemon is not completed.")
