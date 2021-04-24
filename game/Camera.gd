extends Node2D

func _ready():
	small_shake()

# bouge la cameras
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

func small_shake() -> void:
	$Camera2D/ScreenShake.start(1, 50, 4, 0)
