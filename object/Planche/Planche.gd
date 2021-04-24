extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func throw(RelativeDestinationTranslation: Vector2, RelativeDestinationRotation):
	
	# https://godotengine.org/qa/40887/move-a-sprite-with-animation
	# https://docs.godotengine.org/en/stable/classes/class_tween.html#class-tween-method-start
	$Tween.interpolate_property( # translation
		self,
		"position",
		self.position,
		RelativeDestinationTranslation + self.position,
		3,
		Tween.TRANS_BOUNCE,
		Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property( # rotation
		self,
		"rotation",
		self.rotation,
		self.rotation + RelativeDestinationRotation,
		3,
		Tween.TRANS_QUINT,
		Tween.EASE_IN_OUT,
		0
	)
	$Tween.start()


func reset():
	$Tween.stop_all()
