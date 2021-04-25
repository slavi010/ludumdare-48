extends Node2D


var initPosition: Vector2
var initRotation: float
func _ready():
	initPosition = self.position
	initRotation = self.rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# fait tomber le pot de fleur
func fall():
	
	# https://godotengine.org/qa/40887/move-a-sprite-with-animation
	# https://docs.godotengine.org/en/stable/classes/class_tween.html#class-tween-method-start
	$Tween.interpolate_property( # translation
		self,
		"position",
		self.position,
		self.position + Vector2(randi()%100 - 50, 300),
		2,
		Tween.TRANS_QUINT,
		Tween.EASE_IN_OUT
	)
	$Tween.interpolate_property( # rotation
		self,
		"rotation",
		self.rotation,
		(self.rotation + PI*10)*(1 if (randi()%2) else 1),
		2,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT,
		0
	)
	$Tween.start()



func reset():
	$Tween.stop_all()
	self.position = initPosition
	self.rotation = initRotation
