extends Node2D

func _ready():
	pass

# bouge la cameras
func move(destinationTranslation: Vector2, time: float, delay: float):
	# https://docs.godotengine.org/en/stable/classes/class_tween.html#class-tween-method-start
	$Tween.interpolate_property( # translation
		$Camera2D,
		"offset",
		$Camera2D.offset,
		destinationTranslation,
		time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		delay
	)
	$Tween.start()

func zoomIn(destinationZoom: Vector2, time: float, delay: float):
	# zoom ine
	$Tween.interpolate_property(
		$Camera2D,
		"zoom",
		$Camera2D.zoom,
		destinationZoom,
		time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		delay
	)
	$Tween.start()

func reset():
	$Tween.stop_all()
	$Camera2D.zoom = Vector2(1, 1)
	$Camera2D.offset = Vector2(0, 0)
	
func zoomInAndMove(destinationTranslation: Vector2, destinationZoom: Vector2, time: float, delay: float):
	move(destinationTranslation, time, delay)
	zoomIn(destinationZoom, time, delay)

func small_shake() -> void:
	$Camera2D/ScreenShake.start(1, 50, 4, 0)
