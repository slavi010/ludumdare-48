extends Node2D

# signal pour indiquer la fin du kte
# success conrespond au succes du 
signal end(success)

# la touche qui doit être tapée
var key = null
var started = false

func _ready():
	$Timer.connect("timeout", self, "_on_Timer_timeout")



func _physics_process(delta):
	# regarde si le kte est pressé
	if Input.is_action_just_pressed(key) and started:
		emit_signal("end", true)

func start(k, sec: float, delay: float):
	if k == null:
		var r = randi() % 4
		match r:
			0: key = "ui_up"
			1: key = "ui_right"
			2: key = "ui_down"
			3: key = "ui_left"
	else:
		key = k
		
	match key:
		"ui_up": $ButtonSprite.animation = "up"
		"ui_right": $ButtonSprite.animation = "right"
		"ui_down": $ButtonSprite.animation = "down"
		"ui_left": $ButtonSprite.animation = "left"
			
	print(key)
	yield(get_tree().create_timer(delay), "timeout")
	$Timer.one_shot = true
	$Timer.start(sec)
	started = true
	

# callback du timer = échec du kte
func _on_Timer_timeout():
	emit_signal("end", false)
	$ButtonSprite.hide()
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


