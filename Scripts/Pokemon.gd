extends Node2D

var health: int = 100
var max_health: int = 100
var status: Array = []
var completed: bool = false

var possible_status_effects: Array = ["Poisoned", "Burned", "Paralyzed", "Asleep", "Frozen"]

# Add references to the Label nodes in the scene
@onready var hp_label = $HPLabel
@onready var status_label = $StatusLabel
@onready var complete_label = $CompletedLabel

func _ready():
	add_to_group("pokemon")
	health = randi_range(10, max_health)
	print("Pokemon Initialized: ", health, "HP")
	var random_status = possible_status_effects[randi() % possible_status_effects.size()]
	add_status(random_status)
	update_ui()  # Update the UI when the game starts

func update_ui():
	# Update HP label text
	hp_label.text = "HP: %d/%d" % [health, max_health]
	print("UI Updating")
	# Update Status label text (if there are no status effects, show 'None')
	var status_text: String
	if status.size() > 0:
		status_text = "Status: " + status[0]
	else:
		status_text = "Status: Clear"
	
	status_label.text = status_text
	
	if completed == true:
		complete_label.text = "Completed!"
		complete_label.visible=true
	else:
		complete_label.visible=false

func add_status(status_effect: String):
	status.append(status_effect)
	print("Status effect added: ", status_effect)
	update_ui()  # Update the UI after adding a status

func remove_status(status_effect: String):
	if status_effect in status:
		status.erase(status_effect)
		print("Status effect removed: ", status_effect)
	update_ui()  # Update the UI after removing a status
	check_if_completed()

func heal(value: int):
	if health < max_health:
		health += value
		if health > max_health:
			health = max_health
		print("Healed to: ", health, "out of", max_health)
	update_ui()  # Update the UI after healing
	check_if_completed()

func check_if_completed():
	if health == max_health and status.size() == 0:
		completed = true
		print("Pokemon is completed!")
		update_ui()
	else:
		completed = false
		print("Pokemon is not completed.")
