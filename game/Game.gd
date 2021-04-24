extends Node2D


var Qte = load("res://qte/qte.tscn")
var Dialogue = load("res://UI/Dialogue.tscn")

var q

var etape: float = 0
var dialogue = null

func _on_end_dialogue():
	$Camera/Camera2D/QteLayer.remove_child(dialogue)
	dialogue = null	
	match etape:
		0.0: next0_1()
		0.1: next1()
		2.0: next3()
		3.0: next4()

# Called when the node enters the scene tree for the first time.
func _ready():
	next0()

func showDialogue(texts: Array, delay: float, etape: float):
	self.etape = etape	
	dialogue = Dialogue.instance()
	$Camera/Camera2D/QteLayer.add_child(dialogue)
	dialogue.connect("end_dialogue", self, "_on_end_dialogue")
	dialogue.showDialogue(texts, delay)

# le mec est à sa table -> trenblement + "What the fuck" 
func next0():
	# print dialogue delay 2sec	
	showDialogue([
		"~In the tranquil valley of gymnopedia...~",
	], 0, 0)
func next0_1():
	$Camera.small_shake()
	showDialogue([
		"~In the less tranquil valley of gymnopedia…~",
		"You: What the…. Why is my house so giggly all of a sudden ?",
		"You: Wait ! No my flower pot !"
	], 2, 0.1)


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
	showDialogue([
		"You: I got you ! No need to tremble anymore my pretty flower !",
		"You: What’s going on ? "
	], 2, 2)
	$Player.setPosition($Player.positionFleur)


# va dehors + dialogue
func next3():
	$Player.flipH(true) # tourne vers la gauche
	$Player.move($Player.positionPorte, 3, 1)
	yield(get_tree().create_timer(3.5), "timeout")
	# dehors
	$Player.setPosition($Player.positionFleur)
	$Player.move($Player.positionInit, 4, 1)
	showDialogue([
		"You: Wooohaaaaaat ???",
		"Neighbour: Hey little neighbah ! I’ve just installed mah cutie farm  next to yarr house ! Look how mah plant is growing  !",
		"You: (I don’t think we talk about the same plants…)",
		"Neighbour: Yaaaa look at this little neighbah ! This baby can drill more than 3 miles deep !",
		"You: I’m not sure it is a good idea to go deeper and deeper…",
		"Neighbour: Errr, Togethah, at Deeper Industries, we do not need to say dah theme in our dialogues to make a game linked with this yerr's theme !",
		"You: (I shall stop talking with this weirdo, this guy speaks nonsense.)"

	], 3, 3)


func next4():
	#nuit
#	$Player.move($Player.positionPorte, 3, 1)
	next5()

# jour deux
func next5():
	$Player.flipH(false)
	$Player.setPosition($Player.positionInit)
	showDialogue([
		"You: What a strange dream…",
		"You: Nevermind, with all the mess Mr.DrillGuy is making, I shall find a solution to protect my flower.",
		"You: Let’s find my tools !"
	], 1, 5)

# go cave
func next6():
	pass
	
