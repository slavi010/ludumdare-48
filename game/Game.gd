extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$FlowerPot.fall(Vector2(100, 0), PI/2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
