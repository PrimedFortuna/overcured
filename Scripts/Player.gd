extends CharacterBody2D

const SPEED = 260
const RUN_SPEED = 380
var pickup_object = null

@onready var healstation = get_node("../HealStation")
@onready var world = get_parent()
@onready var anim = get_node("./Brendan")
var last_direction = null

func _physics_process(_delta):
	var direction = Vector2.ZERO

	# Handle movement inputs and play the correct animation
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		last_direction = "right"
		if Input.is_action_pressed("ui_shift"):
			anim.play("walk_right_speed")
		else:
			anim.play("walk_right")
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		last_direction = "left"
		if Input.is_action_pressed("ui_shift"):
			anim.play("walk_left_speed")
		else:
			anim.play("walk_left")
			
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
		last_direction = "down"
		if Input.is_action_pressed("ui_shift"):
			anim.play("walk_down_speed")
		else:
			anim.play("walk_down")
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		last_direction = "up"
		if Input.is_action_pressed("ui_shift"):
			anim.play("walk_up_speed")
		else:
			anim.play("walk_up")

	# Handle idle animations if no movement input is detected
	if direction == Vector2.ZERO:
		if last_direction == "down":
			anim.play("idle_down")
		elif last_direction == "up":
			anim.play("idle_up")
		elif last_direction == "left":
			anim.play("idle_left")
		elif last_direction == "right":
			anim.play("idle_right")

	# Update velocity for movement
	var current_speed = SPEED if not Input.is_action_pressed("ui_shift") else RUN_SPEED
	velocity = direction.normalized() * current_speed
	move_and_slide()

func interact(item = null):
	if item == null:
		item = find_nearest_pickup_item()

	var nearest_crafter = find_nearest_crafter()  # Local variable, no shadowing

	# If holding an item and near a crafter, drop the item into the crafter
	if pickup_object and nearest_crafter:
		print("Dropping", pickup_object.name, "into Crafter")
		remove_child(pickup_object)  # Remove from player
		nearest_crafter.add_item_to_crafter(pickup_object)  # Give to Crafter
		print("Item added to crafter.")
		# Scale down item when added to crafter
		pickup_object.scale = Vector2(0.4, 0.4)
		pickup_object = null  # Player is now empty
		return

	# Picking up an item
	if item and pickup_object == null and global_position.distance_to(item.global_position) < 160:
		print("Picked up Item:", item.name)
		if item.get_parent():
			item.get_parent().remove_child(item)
		pickup_object = item
		add_child(pickup_object)
		pickup_object.position = Vector2(0, -25)
		pickup_object.scale = Vector2(1, 1)
		move_child(pickup_object, 3)
		pickup_object.visible = true
		return

	var nearest_table = find_nearest_table()
	print("Nearest table:", nearest_table)

	# Picking up from a table
	if pickup_object == null and nearest_table:
		var last_item = nearest_table.remove_item_from_table()
		if last_item:
			print("Picked up from table:", last_item.name)
			if last_item.get_parent():
				last_item.get_parent().remove_child(last_item)
			pickup_object = last_item
			add_child(pickup_object)
			pickup_object.position = Vector2(0, -25)
			pickup_object.scale = Vector2(1, 1)
			move_child(pickup_object, 3)
			pickup_object.visible = true
			return

	# Picking up from Healstation
	elif pickup_object == null and is_near_healstation():
		var last_item = healstation.remove_item_from_healstation()
		if last_item:
			print("Picked up from healstation:", last_item.name)
			if last_item.get_parent():
				last_item.get_parent().remove_child(last_item)
			pickup_object = last_item
			add_child(pickup_object)
			pickup_object.position = Vector2(0, -25)
			pickup_object.scale = Vector2(1, 1)
			move_child(pickup_object, 3)
			pickup_object.visible = true
			return

	# Dropping an item on a table
	elif pickup_object != null:
		if nearest_table:
			print("Trying to drop item on table:", pickup_object.name)
			remove_child(pickup_object)
			nearest_table.add_item_to_table(pickup_object)
			print("Item new parent after adding to table:", pickup_object.get_parent())
			# Removed rotation change, no longer rotate item
			pickup_object.scale = Vector2(1.2, 1.2)
			pickup_object = null
		elif is_near_healstation():
			if pickup_object.is_in_group("pokeballs"):
				print("Dropped on healstation:", pickup_object.name)
				remove_child(pickup_object)
				healstation.add_item_to_healstation(pickup_object)
				print("Item new parent after adding to healstation:", pickup_object.get_parent())
				pickup_object.scale = Vector2(1.2, 1.2)
				pickup_object = null
			else:
				print("Can't drop this item on the healstation! Only Pokeballs can be dropped here.")
		else:
			print("Dropped on ground:", pickup_object.name)
			if pickup_object.get_parent():
				pickup_object.get_parent().remove_child(pickup_object)
			world.add_child(pickup_object)
			world.move_child(pickup_object, 1)
			pickup_object.global_position = global_position + Vector2(0, 20)
			print("Item new parent after dropping on ground:", pickup_object.get_parent())
			pickup_object.visible = true
			pickup_object.scale = Vector2(2, 2)
			pickup_object = null

func find_nearest_pickup_item() -> Node:
	var nearest_item = null
	var min_distance = 120

	for item in get_tree().get_nodes_in_group("pickups"):
		if item and item is Node2D:
			var distance = global_position.distance_to(item.global_position)
			if distance < min_distance:
				nearest_item = item
				min_distance = distance

	return nearest_item

func find_nearest_table() -> Node:
	var nearest_table = null
	var min_distance = 128
	var tables = get_tree().get_nodes_in_group("tables")

	for table in tables:
		var distance = global_position.distance_to(table.global_position)
		print("Checking distance:", distance)

		if distance < min_distance:
			nearest_table = table
			min_distance = distance

	return nearest_table

func is_near_healstation() -> bool:
	if healstation:
		return global_position.distance_to(healstation.global_position) < 160
	else:
		print("Healstation not found!")
		return false

# Local function to find the nearest crafter
func find_nearest_crafter() -> Node:
	if not is_inside_tree():
		print("find_nearest_crafter() called too early!")
		return null  # Prevent the error

	var nearest_crafter = null  # Local variable
	var min_distance = 128  # Adjust range if needed

	for crafter in get_tree().get_nodes_in_group("crafters"):
		var distance = global_position.distance_to(crafter.global_position)
		if distance < min_distance:
			nearest_crafter = crafter
			min_distance = distance

	return nearest_crafter
