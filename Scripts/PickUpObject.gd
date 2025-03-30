extends Area2D

var original_name: String  # To store the original name

func _ready():
	print("Pickup script is running!")
	add_to_group("pickups")

	original_name = name  # Store the original name in a variable

	if "Pokeball" in name:
		add_to_group("pokeballs")
		
	if "Berry" in name:
		add_to_group("berry")
		
# Add potions to the "potion" group
	if "Potion" in name or "Revive" in name:
		add_to_group("potion")

# Add status effect curing items to the "heals" group
	if "Antidote" in name or "Awakening" in name or "FullHeal" in name or "FullRestore" in name or "HealPowder" in name or "IceHeal" in name or "ParalyzeHeal" in name:
		add_to_group("heals")
