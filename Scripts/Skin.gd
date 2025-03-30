extends Node2D

@onready var skinSprite = $CompositeSprites/Sprite
const Sprites = preload("res://Scripts/Sprites.gd")  

var curr_skin: int = Global.selected_skin
var sprites_instance

func _ready():
	# Create one instance and store it for reuse
	sprites_instance = Sprites.new()
	skinSprite.texture = sprites_instance.charSprites[curr_skin]

func _on_button_pressed() -> void:
	curr_skin = (curr_skin + 1) % sprites_instance.charSprites.size()
	skinSprite.texture = sprites_instance.charSprites[curr_skin]


func _on_button_2_pressed() -> void:
	curr_skin = (curr_skin + 1) % sprites_instance.charSprites.size()
	skinSprite.texture = sprites_instance.charSprites[curr_skin]


func _on_button_3_pressed() -> void:
	Global.selected_skin = curr_skin
