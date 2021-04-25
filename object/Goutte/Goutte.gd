extends Node2D


func _ready():
	pass # Replace with function body.

func fall(destinationTranslation: Vector2):
	
	# https://godotengine.org/qa/40887/move-a-sprite-with-animation
	# https://docs.godotengine.org/en/stable/classes/class_tween.html#class-tween-method-start
	$Tween.interpolate_property( # translation
		self,
		"position",
		self.position,
		destinationTranslation,
		4,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	$Tween.start()


func reset():
	$Tween.stop_all()
