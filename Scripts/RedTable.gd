extends Node2D

var max_items: int = 6  
var pickup_pokemon: Array = []  # Renaming to pickup_pokemon to reflect that we're dealing with Pokémon now

@onready var grid_container: GridContainer = $GridContainer  

func _ready():
	add_to_group("tables")

# Add a Pokémon to the table
func add_pokemon_to_table(pokemon: Node2D):  # Make sure pokemon is a Node2D (or extend appropriately)
	if pickup_pokemon.size() < max_items:
		if pokemon.get_parent():
			pokemon.get_parent().remove_child(pokemon)  # Remove Pokémon from its current parent if it's already in the scene

		pickup_pokemon.append(pokemon)  # Add the Pokémon to our table's list
		grid_container.add_child(pokemon)  # Add the Pokémon to the grid container

		pokemon.visible = true  # Make Pokémon visible
		pokemon.scale = Vector2(1.2, 1.2)  # Scale the Pokémon to maintain a ratio
		pokemon.rotation_degrees = -90  # Rotate the Pokémon (optional)
		pokemon.position = Vector2.ZERO  # Set the Pokémon position at (0,0) inside the grid

		update_pokemon_positions() 
		check_pokemon_and_delete()
		print("Pokémon added to table:", pokemon.name)
	else:
		print("Table is full, can't add more Pokémon.")

# Remove a Pokémon from the table
func remove_pokemon_from_table() -> Node2D:
	if pickup_pokemon.size() > 0:
		var last_pokemon = pickup_pokemon.pop_back()  # Remove the last Pokémon from the list
		last_pokemon.rotation_degrees = 0  # Reset rotation
		grid_container.remove_child(last_pokemon)  # Remove it from the container
		update_pokemon_positions()  # Recalculate item positions
		last_pokemon.visible = true  # Ensure the Pokémon is visible when removed
		print("Pokémon removed from table:", last_pokemon.name)
		return last_pokemon
	else:
		print("Table is empty.")
		return null

# Update positions of Pokémon inside the grid container
func update_pokemon_positions():
	var cols = 3
	var rows = 2
	var container_size = grid_container.get_rect().size  # Get actual size of the grid container
	var padding = 8  # Space between items
	
	# Determine item size dynamically based on available space
	var item_size_x = (container_size.x - (cols - 1) * padding) / cols
	var item_size_y = (container_size.y - (rows - 1) * padding) / rows
	var item_size = Vector2(item_size_x, item_size_y)

	# Adjust starting X and Y position to center items within the container
	var start_x = (container_size.x - (cols * item_size.x + (cols - 1) * padding)) / 2
	var start_y = (container_size.y - (rows * item_size.y + (rows - 1) * padding)) / 2

	# Position each Pokémon inside the grid
	for i in range(pickup_pokemon.size()):
		var col = i % cols
		var row = i / cols
		pickup_pokemon[i].position = Vector2(
			start_x + col * (item_size.x + padding),
			start_y + row * (item_size.y + padding)
		)

# New function to check if the table name is "Output" and Pokémon is completed, then delete it
func check_pokemon_and_delete():
	if name == "Output":  # Check if the table name is "Output"
		for pokemon in pickup_pokemon:
			if pokemon.has_method("check_if_completed") and pokemon.check_if_completed():  # Check if the Pokémon is completed
				print("Pokémon completed and returned:", pokemon.name)
				pokemon.queue_free()  # Remove the Pokémon from the scene (delete it)
				pickup_pokemon.erase(pokemon)  # Remove it from the list
				update_pokemon_positions()  # Update the grid layout after deletion
				break  # Exit after removing the first completed Pokémon
