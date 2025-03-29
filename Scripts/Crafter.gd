extends Node2D

var max_items: int = 2  # Assuming the crafter only allows two items to be added
var input_items: Array = []  # Store the input items here

@export var craft_time: float = 5.0  # Declare and export the crafting time

@onready var grid_container: GridContainer = $GridContainer  # Reference to the GridContainer node
@onready var timer = $Timer  # Timer for crafting process

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

func add_item_to_crafter(item: Node):
	if input_items.size() < max_items:
		# If the item already has a parent, remove it
		if item.get_parent():
			item.get_parent().remove_child(item)

		# Add the item to the crafter and the grid container
		input_items.append(item)
		grid_container.add_child(item)

		# Set visibility and scale for the item
		item.visible = true
		item.scale = Vector2(1, 1)
		item.position = Vector2.ZERO

		# Update item positions inside the grid container
		update_item_positions()
		print("Item added to crafter:", item.name)
	else:
		print("Crafter is full, can't add more items.")

func remove_item_from_crafter() -> Node:
	if input_items.size() > 0:
		var last_item = input_items.pop_back()
		grid_container.remove_child(last_item)
		update_item_positions()
		last_item.visible = true
		print("Picked up from crafter:", last_item.name)
		return last_item
	else:
		print("Crafter is empty.")
		return null

func update_item_positions():
	var cols = 2  # Assuming a grid with 2 columns
	var rows = 1  # Only one row for two items
	var container_size = grid_container.get_rect().size  # Get the actual size of the container
	var padding = 8  # Space between items
	
	# Calculate item size dynamically based on available space
	var item_size_x = (container_size.x - (cols - 1) * padding) / cols
	var item_size_y = container_size.y  # One row takes up full height

	# Starting positions for items in the grid
	var start_x = (container_size.x - (cols * item_size_x + (cols - 1) * padding)) / 2
	var start_y = (container_size.y - item_size_y) / 2

	# Position each item in the grid
	for i in range(input_items.size()):
		var col = i % cols
		var row = i / cols
		input_items[i].position = Vector2(
			start_x + col * (item_size_x + padding),
			start_y + row * (item_size_y + padding)
		)

# Crafting logic
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
		timer.start(craft_time)  # Start crafting process
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

	# Instantiate the crafted item if crafting was successful
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
