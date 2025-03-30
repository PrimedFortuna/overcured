extends Node2D

@onready var skinSprite = $CompositeSprites/Sprite
const Sprites = preload("res://Assets/Sprites/Sprites.gd")
 

var curr_skin: int = 0
var sprites_instance

func _ready():
	sprites_instance = Sprites.new()
	skinSprite.texture = sprites_instance.charSprites[curr_skin]
	$BackButton.connect("pressed", _on_back_pressed) 
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Settings.tscn")

func _on_button_pressed() -> void:
	curr_skin = (curr_skin + 1) % sprites_instance.charSprites.size()
	skinSprite.texture = sprites_instance.charSprites[curr_skin]


func _on_button_2_pressed() -> void:
	curr_skin = (curr_skin + 1) % sprites_instance.charSprites.size()
	skinSprite.texture = sprites_instance.charSprites[curr_skin]
