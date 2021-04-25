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
	for text in texts:
		$TextBox.queue_text(text)
	


func _on_TextBox_finished():
	emit_signal("end_dialogue")
