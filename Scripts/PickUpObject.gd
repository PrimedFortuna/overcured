extends Area2D 

func _ready():
	print("Pickup script is running!")
	add_to_group("pickups")

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
