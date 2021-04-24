extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# fait tomber le pot de fleur
func fall(RelativeDestinationTranslation: Vector2, RelativeDestinationRotation):
	
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
		1.5
	)
	$Tween.start()
	
