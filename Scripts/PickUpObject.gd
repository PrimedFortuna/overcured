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
		
	if "OranBerry" in name:
		add_to_group("potion")
		
	if "Potion" in name:
		add_to_group("superPotion")
		
	if "EnergyPowder" in name:
		add_to_group("superPotion")
		
	if "Potion" in name:
		add_to_group("hyperPotion")
		
	if "EnergyRoot" in name:
		add_to_group("hyperPotion")
		
	if "HyperPotion" in name:
		add_to_group("maxPotion")
		
	if "OranBerry" in name:
		add_to_group("antidote")
	
	if "PechaBerry" in name:
		add_to_group("antidote")
		
	if "OranBerry" in name:
		add_to_group("awakening")
		
	if "ChestoBerry" in name:
		add_to_group("awakening")
		
	if "OranBerry" in name:
		add_to_group("burnHeal")
		
	if "RawstBerry" in name:
		add_to_group("burnHeal")
		
	if "OranBerry" in name:
		add_to_group("iceHeal")
		
	if "AspearBerry" in name:
		add_to_group("iceHeal")
		
	if "OranBerry" in name:
		add_to_group("paralyzeHeal")

	if "CheriBerry" in name:
		add_to_group("paralyzeHeal")
