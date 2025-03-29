extends Node2D

var input_items = []
@export var craft_time: float = 5.0
@onready var timer = $Timer

# Recipe dictionary mapping item object reference combinations to crafted items
var recipes = {
	[&"OranBerry", &"OranBerry"]: "Potion",
	[&"OranBerry", &"PechaBerry"]: "Antidote",
	[&"OranBerry", &"ChestoBerry"]: "Awakening",
	[&"OranBerry", &"RawstBerry"]: "BurnHeal",
	[&"OranBerry", &"AspearBerry"]: "IceHeal",
	[&"Potion", &"Potion"]: "SuperPotion",
	[&"Potion", &"EnergyPowder"]: "SuperPotion",
	[&"Potion", &"EnergyRoot"]: "HyperPotion",
	[&"HyperPotion", &"HyperPotion"]: "MaxPotion",
	[&"MaxPotion", &"HealPowder"]: "FullHeal",
	[&"MaxPotion", &"RevivalHerb"]: "Revive",
	[&"Revive", &"SacredAsh"]: "MaxRevive"
}

var crafted_item_name = ""  # Store crafted item for later

func _ready():
	add_to_group("crafters")

func add_item(item):
	if input_items.size() < 2:
		input_items.append(item)
		print("Added:", item.name)

		if input_items.size() == 2:
			start_crafting()

func start_crafting():
	# Collect the names for both input items
	var item_references = []
	for item in input_items:
		item_references.append(item.name)

	# Sort item names to ensure consistent recipe matching
	item_references.sort()

	# Find the matching recipe
	var possible_recipes = []
	for recipe_items in recipes.keys():
		# Sort recipe items to ensure consistent comparison
		var sorted_recipe = recipe_items.duplicate()
		sorted_recipe.sort()

		# If the sorted item names match the sorted recipe items, store the recipe
		if item_references == sorted_recipe:
			possible_recipes.append(recipes[recipe_items])

	if possible_recipes.size() > 0:
		# Start crafting the first valid recipe
		crafted_item_name = possible_recipes[0]
		timer.start(craft_time)  # Start crafting
		print("Crafting:", crafted_item_name)
	else:
		# No valid recipe, drop the items
		print("Invalid recipe:", item_references)
		drop_items()

# This function will be called when the timer completes
func _on_Timer_timeout():
	# Remove input items from the crafter
	for item in input_items:
		if item.get_parent():
			item.get_parent().remove_child(item)
			item.queue_free()

	input_items.clear()

	# Instantiate the crafted item
	if crafted_item_name != "":
		var crafted_item = load("res://Scenes/Items/%s.tscn" % crafted_item_name).instantiate()
		crafted_item.global_position = global_position
		get_parent().add_child(crafted_item)

		print("Crafted:", crafted_item_name)
		crafted_item_name = ""  # Reset for next crafting

# Drop the input items if no valid recipe is found
func drop_items():
	for item in input_items:
		if item.get_parent():
			item.get_parent().remove_child(item)
			item.queue_free()

	input_items.clear()
