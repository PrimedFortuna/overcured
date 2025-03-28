extends Area2D 

func _ready():
	print("Pickup script is running!")
	add_to_group("pickups")  

	if "Pokeball" in name:
		add_to_group("pokeballs")
		
	if "Berry" in name:
		add_to_group("berry")
