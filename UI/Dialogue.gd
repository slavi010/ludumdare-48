extends Node2D

signal end_dialogue

var texts : Array
var idx = 0

var chowed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func showDialogue(texts: Array, delay: float):
	yield(get_tree().create_timer(delay + 0.1), "timeout")
	self.texts = texts
	chowed = true
	showNext()
	
func showNext():
	if texts.size() > idx:
		print(texts[idx])
		idx += 1
	elif idx != 9999:
		emit_signal("end_dialogue")
		idx = 9999
	else:
		pass


func _process(delta):
	if Input.is_action_just_pressed("ui_up") and chowed:
		showNext()
	
