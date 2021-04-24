extends Node2D


var Qte = load("res://qte/qte.tscn")
var Dialogue = load("res://UI/Dialogue.tscn")

var q

var etape: float = 0
var dialogue = null


func _physics_process(delta):
	# input quand un dialogue est passé
	if Input.is_action_just_pressed("ui_up") \
		and dialogue != null:
		dialogue = null
		$Camera/Camera2D/QteLayer.remove_child(dialogue)
		match etape:
			0.0: next1()
			2.0: next3()

# Called when the node enters the scene tree for the first time.
func _ready():
	next0()

func showDialogue(texte: String, startPosition: Vector2, delay: float, etape: float):
	self.etape = etape	
	dialogue = Dialogue.instance()
	$Camera/Camera2D/QteLayer.add_child(dialogue)
	dialogue.showDialogue(texte, startPosition, delay)

func sleep(sec: float):
	yield(get_tree().create_timer(sec), "timeout")

# le mec est à sa table -> trenblement + "What the fuck" 
func next0():
	$Camera.small_shake()
	# print dialogue delay 2sec	
	showDialogue("What the fuck", Vector2(0, 0), 2, 0)
	

func next1():
	$FlowerPot.fall(Vector2(-100, 0), -PI)
	$Player.move($Player.positionFleur, 3, 2)
	$Camera.zoomInAndMove(Vector2(200, 0), Vector2(0.4, 0.4), 4, 2)
	q = Qte.instance()
	$Camera/Camera2D/QteLayer.add_child(q)
	q.connect("end", self, "on_qte_end")	
	q.start("ui_up", 3, 2)
	
func on_qte_end(success):
	print(success)
	$Camera/Camera2D/QteLayer.remove_child(q)
	$Camera.reset()
	$FlowerPot.reset()
	if success: next2()
	else: faild1()

func faild1():
	# NOOOO
	# restart
	pass

# affiche dialogue "I got you"
func next2():
	showDialogue("I got you", Vector2(0, 0), 2, 2)
	$Player.setPosition($Player.positionFleur)
	

# va dehors + dialogue
func next3():
	$Player.move($Player.positionPorte, 3, 1)
#	sleep(3)
#	$Player.setPosition($Player.positionFleur)
#	$Player.move($Player.positionInit, 2, 1)
	
	
