extends Node2D

export var positionInit : Vector2
export var positionFleur : Vector2
export var positionPorte : Vector2

# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# bouge le Player
func move(destinationTranslation: Vector2, time: float, delay: float):
	# https://docs.godotengine.org/en/stable/classes/class_tween.html#class-tween-method-start
	$Tween.interpolate_property( # translation
		self,
		"position",
		self.position,
		destinationTranslation,
		time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		delay
	)
	$Tween.start()
	
func setPosition(newPosition: Vector2):
	$Tween.stop(self, "position")
	self.position = newPosition
