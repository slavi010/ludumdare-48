extends Node2D

# signal pour indiquer la fin du kte
# success conrespond au succes du 
signal end(success)

# la touche qui doit être tapée
var key = null

func _ready():
	$"Timer".connect("timeout", self, "_on_Timer_timeout")



func _physics_process(delta):
	# regarde si le kte est pressé
	if Input.is_action_just_pressed("ui_up") and key == "ui_up":
		emit_signal("end", true)

func setKeyToPress(k: String):
	key = k

func setWaitTimeAndStart(sec: float):
	$"Timer".one_shot = true	
	$"Timer".start(sec)

# callback du timer = échec du kte
func _on_Timer_timeout():
	emit_signal("end", false)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
