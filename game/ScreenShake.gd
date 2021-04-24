# https://www.codingkaiju.com/tutorials/screen-shake-in-godot-the-best-way/
extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0
var initPos = Vector2()

onready var camera = get_parent().get_parent()

func start(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	if (priority >= self.priority):
		self.priority = priority
		self.amplitude = amplitude
		if initPos.x == 0 && initPos.y == 0:
			self.initPos = camera.position
		
		$Duration.wait_time = duration
		$Frequency.wait_time = 1 / float(frequency)
		$Duration.start()
		$Frequency.start()

		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-amplitude, amplitude)
	rand.y = rand_range(-amplitude, amplitude)

	$ShakeTween.interpolate_property(camera, "position", camera.position, rand, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()
	print("shake start")

func _reset():
	$ShakeTween.interpolate_property(camera, "position", camera.position, initPos, $Frequency.wait_time, TRANS, EASE)
	$ShakeTween.start()

	priority = 0
	initPos = Vector2()

func _on_Frequency_timeout():
	_new_shake()


func _on_Duration_timeout():
	_reset()
	$Frequency.stop()

#func _process(delta):
#	print(camera.position)
