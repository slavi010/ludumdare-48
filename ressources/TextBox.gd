extends CanvasLayer

signal finished

const CHAR_READ_RATE = 0.10

onready var textbox_container = $Box
onready var Name = $Box/MarginContainer/VBoxContainer/Name
onready var label = $Box/MarginContainer/VBoxContainer/Text
var player = null

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _ready():
	print("Starting state: State.READY")
	hide_textbox()

func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_up"):
				label.percent_visible = 1.0
				$Tween.stop_all()
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_up"):
				change_state(State.READY)
				if player != null:
					player.stop()
					self.remove_child(player)
				if text_queue.empty():
					emit_signal("finished")
					hide_textbox()
				

func queue_text(next_text: Array):
	text_queue.push_back(next_text)

func hide_textbox():
	Name.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	textbox_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	Name.text = next_text[0]
	label.text = next_text[1]
	player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load("res://sounds/"+next_text[2])
	player.play()
	label.percent_visible = 0.0
	change_state(State.READING)
	show_textbox()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISHED:
			print("Changing state to: State.FINISHED")

func _on_Tween_tween_completed(object, key):
	change_state(State.FINISHED)
