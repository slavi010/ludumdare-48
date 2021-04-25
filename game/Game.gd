extends Node2D


var Qte = load("res://qte/qte.tscn")
var Dialogue = load("res://UI/Dialogue.tscn")
var Planche = load("res://object/Planche/Planche.tscn")
var Goutte = load("res://object/Goutte/Goutte.tscn")
var TNT = load("res://object/TNT/TNT.tscn")
var q

var etape: float = 0
var dialogue = null

func _on_end_dialogue():
	$Camera/Camera2D/QteLayer.remove_child(dialogue)
	dialogue = null	
	match etape:
		0.0: next0_1()
		0.1: next1()
		1.0: next0() # from failure
		2.0: next3()
		3.0: next4()
		4.0: next5() # nuit
		5.0: next6()
		6.0: next5() # from failure
		7.0: next8()
		8.0: next5() # from failure
		9.0: next10()
		10.0: next11()
		11.0: next12()
		12.0: next13()
		13.0: next11() # from failure
		14.0: next15() 
		15.0: next16() 
		16.0: next17() # nuit
		17.0: next18() 
		18.0: next19() 
		19.0: next17() # from failure 
		20.0: next21()
		21.0: next22()
		22.0: next23()
		23.0: next21() # from failure
		24.0: next25() 
		25.0: next26() # nuit
		26.0: next27()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	next0()
	
func fail():
	$Maison.animation = "etoile"
	$Maison/In.hide()
	$Maison/Out.hide()
	$Player.hide()

func showDialogue(texts: Array, delay: float, etape: float):
	self.etape = etape	
	dialogue = Dialogue.instance()
	$Camera/Camera2D/QteLayer.add_child(dialogue)
	dialogue.connect("end_dialogue", self, "_on_end_dialogue")
	dialogue.showDialogue(texts, delay)

# le mec est à sa table -> trenblement + "What the fuck" 
func next0():
	$Maison.animation = "maison"
	$Maison/In.show()
	$Maison/Out.hide()
	$Maison/In/FlowerPot.reset()
	$Maison.show()
	$Player.show()
	$Player.anim($Player.ANIMATION_MEAL)
	$Player.setPosition($Player.positionMeal)
	$Maison/In/Fish/AnimatedSprite.animation = "normal"
	# print dialogue delay 2sec	
	showDialogue([
		["~~~", "In the tranquil valley of gymnopedia..."],
	], 1, 0)
func next0_1():
	$Camera.small_shake()
	showDialogue([
		["~~~", "In the less tranquil valley of gymnopedia..."],
		["You", "What the.... Why is my house so giggly all of a sudden ?"],
		["You", "Wait ! No my flower pot !"]
	], 2, 0.1)

func next1():
	$Maison/In/FlowerPot.fall(Vector2(-100, 0), -PI)
	yield(get_tree().create_timer(2), "timeout")
	$Player.move($Player.positionFleur, 3, 0)
	$Player.anim($Player.ANIMATION_RUN)
	$Camera.zoomInAndMove(Vector2(200, 0), Vector2(0.4, 0.4), 4, 0)
	q = Qte.instance()
	$Camera/Camera2D/QteLayer.add_child(q)
	q.connect("end", self, "on_qte_end_1")	
	q.start("ui_up", 3, 0.2)
	$Camera/Camera2D/ScreenShake.start(1.2, 8, 10, 1)
	
func on_qte_end_1(success):
	print(success)
	$Camera/Camera2D/ScreenShake._reset()
	$Camera/Camera2D/QteLayer.remove_child(q)
	$Camera.reset()
	$Maison/In/FlowerPot.reset()
	if success: next2()
	else: faild1()

func faild1():
	fail()
	showDialogue([
		["~~~", "GAME OVER"],
	], 1, 1)
	

# affiche dialogue "I got you"
func next2():
	$Player.anim($Player.ANIMATION_ANGRY)
	showDialogue([
		["You", "I got you ! No need to tremble anymore my pretty flower !"],
		["You", "What’s going on ? "]
	], 1, 2)
	$Player.setPosition($Player.positionFleur)


# va dehors + dialogue
func next3():
	
	$Player.flipH(true) # tourne vers la gauche
	$Player.anim($Player.ANIMATION_WALK)	
	$Player.move($Player.positionPorte, 3, 0.3)
	yield(get_tree().create_timer(2.5), "timeout")
	$Transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	# dehors
	$Maison.animation = "dehors"
	$Maison/In.hide()
	$Maison/Out.show()
	$Player.setPosition($Player.positionFleur)
	$Player.move($Player.positionInit, 4, 0.3)
	showDialogue([
		["You", "Wooohaaaaaat ???"],
		["Deeper", "Hey little neighbah ! I’ve just installed mah cutie farm  next to yarr house ! Look how mah plant is growing  !"],
		["You", "(I don’t think we talk about the same plants...)"],
		["Deeper", "Yaaaa look at this little neighbah ! This baby can drill more than 3 miles deep !"],
		["You", "I’m not sure it is a good idea to go deeper and deeper..."],
		["Deeper", "Errr, Togethah, at Deeper Industries, we do not need to say dah theme in our dialogues to make a game linked with this yerr's theme !"],
		["You", "(I shall stop talking with this weirdo, this guy speaks nonsense.)"]

	], 3, 3)
	yield(get_tree().create_timer(4), "timeout")
	$Player.anim($Player.ANIMATION_ANGRY)

# dream 1
func next4():
	$Transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	$Maison.animation = "dream1"
	$Maison/In.hide()
	$Maison/Out.hide()
	$Player.hide()
	showDialogue([
		["???", "????? ?????"],
	], 2, 4)

# jour deux
func next5():
	$Transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	$Maison.animation = "maison"
	$Maison/In.show()
	$Maison/Out.hide()
	$Player.show()
	$Player.flipH(false)
	
	$Player.anim($Player.ANIMATION_MEAL)
	$Player.setPosition($Player.positionMeal)
	$Player.show()
	$Camera.reset()
	$Maison/In/Trape/AnimatedSprite.animation = "close"
	
	showDialogue([
		["You", "What a strange dream..."],
		["You", "Nevermind, with all the mess Mr.DrillGuy is making, I shall find a solution to protect my flower."],
		["You", "Let’s find my tools !"]
	], 1, 5)

# go cave
func next6():
	$Camera.zoomInAndMove(Vector2(160, 160), Vector2(0.45, 0.45), 4, 0)
	$Player.anim($Player.ANIMATION_WALK)
	$Player.move($Player.positionCave, 2, 0)
	yield(get_tree().create_timer(2), "timeout")
	$Player.anim($Player.ANIMATION_HAPPY)
	
	q = Qte.instance()
	$Camera/Camera2D/QteLayer.add_child(q)
	q.connect("end", self, "on_qte_end_6")	
	q.start("ui_up", 3, 0.3)
	$Camera/Camera2D/ScreenShake.start(1.2, 8, 10, 1)
	
func on_qte_end_6(success):
	$Camera/Camera2D/ScreenShake._reset()
	$Camera/Camera2D/QteLayer.remove_child(q)
	if success:
		$Transition.transition()
		yield(get_tree().create_timer(1), "timeout")
		next7()
	else: fail6()

func fail6():
	fail()
	showDialogue([
		["~~~", "GAME OVER"],
	], 1, 6)


func next7():
	# open trap
	$Player.hide()
	$Maison/In/FlowerPot.hide()
	$Maison/In/Trape/AnimatedSprite.animation = "open"
	$Camera/Camera2D/ScreenShake.start(1, 2, 60, 2)
	showDialogue([
		["You", "Woah it’s pretty dark in here !"],
		["You", "Okay let’s create the perfect fall proof flower pot"],
	], 1, 7)
	

# dans la cave
var next8NbQteLeft = 4
var planche
func next8():
	planche = Planche.instance()
	planche.throw(Vector2(randi()%200-100, randi()%200-100), randi()%4-2)  
	planche.visible = true
	
	q = Qte.instance()
	$Camera/Camera2D/QteLayer.add_child(q)
	$Camera/Camera2D/QteLayer.add_child(planche)
	q.connect("end", self, "on_qte_end_8")	
	q.start(null, 3, 0.2)
	$Camera/Camera2D/ScreenShake.start(1.2, 8, 10, 1)

func on_qte_end_8(success):
	$Camera/Camera2D/ScreenShake._reset()
	$Camera/Camera2D/QteLayer.remove_child(q)
	$Camera/Camera2D/QteLayer.remove_child(planche)
	yield(get_tree().create_timer(1), "timeout")
	print("next8NbQteLeft ", next8NbQteLeft)
	if success:
		if next8NbQteLeft <= 1:
			$Transition.transition()
			yield(get_tree().create_timer(1), "timeout")
			next9()
		else:
			next8NbQteLeft -= 1
			next8()
	else: fail6()
	
func fail8():
	fail()
	showDialogue([
		["~~~", "GAME OVER"],
	], 1, 8)
	
func next9():
	
	$Camera.reset()
	$Player.show()
	$Player.anim($Player.ANIMATION_HAPPY)
	$Maison/In/FlowerPot.show()
	$Maison/In/FlowerPot/AnimatedSprite.animation = "cage"
	$Maison/In/Fish/AnimatedSprite.animation = "normal"
	showDialogue([
		["You", "Phew, that was quite the work ! Well yeah, I could have turned the light on, but it would have been less fun !"],
		["You", "And here is the protectaflower 2000 ! With this, no more earthquake hazards !"],
	], 1, 9)
	
# its work
func next10():
	yield(get_tree().create_timer(1), "timeout")
	$Camera.small_shake()
	showDialogue([
		["You", "It’s working ! "],
		["You", "Rose are red, Violets are blue and nothing bad will happen to me and you !"],
	], 1, 10)
	

# crack
func next11():
	$Maison/In.show()
	$Maison/Out.hide()
	$Player.show()
	$Camera.reset()
	$Player.setPosition($Player.positionCave)
	$Player.anim($Player.ANIMATION_HAPPY)
	# TODO crack sond
	yield(get_tree().create_timer(1), "timeout")
	$Player.anim($Player.ANIMATION_ANGRY)
	print("crack")
	showDialogue([
		["You", "Cracks ? What do you mean cracks !?"],
	], 2, 11)

# crack again
func next12():
	yield(get_tree().create_timer(1), "timeout")
	# TODO crack sond again
	print("crack")
	$Maison/In/Fish/AnimatedSprite.animation = "fissure"
	showDialogue([
		["You", "Maurice the fish is in danger ! I have to help it ! That clearly is a flex tape situation."],
	], 2, 12)

func next13():
	$Player.move($Player.positionFlexTape, 2, 0)
	$Player.anim($Player.ANIMATION_RUN)
	$Camera.zoomInAndMove($Player.positionFlexTape, Vector2(0.45, 0.45), 2.5, 0)
	$Player.flipH(true)
	q = Qte.instance()
	$Camera/Camera2D/QteLayer.add_child(q)
	q.connect("end", self, "on_qte_end_13")	
	q.start("ui_up", 2, 0.2)
	$Camera/Camera2D/ScreenShake.start(1.2, 8, 8, 1)
	
func on_qte_end_13(success):
	print(success)
	$Camera/Camera2D/ScreenShake._reset()
	$Camera/Camera2D/QteLayer.remove_child(q)
	
	$Maison/In/FlowerPot.reset()
	if success: next14()
	else: fail13()

func fail13():
	fail()
	showDialogue([
		["~~~", "GAME OVER"],
	], 1, 13)

func next14():
	$Camera.reset()
	$Player.anim($Player.ANIMATION_FIXETAPE)
	yield(get_tree().create_timer(0.7), "timeout")
	$Maison/In/Fish/AnimatedSprite.animation = "flextape"
	$Player.anim($Player.ANIMATION_HAPPY)
	showDialogue([
		["You", "Good old flex tape... Can fix any situations... I guess ? "],
		["You", "No it cannot fix my neighbor, but I can fix him."],
	], 1, 14)

func next15():
	$Player.flipH(true) # tourne vers la gauche
	$Player.anim($Player.ANIMATION_WALK)	
	$Player.move($Player.positionPorte, 2, 0.1)
	yield(get_tree().create_timer(2.1), "timeout")
	# dehors
	$Maison.animation = "dehors"
	$Maison/In.hide()
	$Maison/Out.show()
	$Player.setPosition($Player.positionFleur)
	$Player.move($Player.positionInit, 3, 0.3)
	showDialogue([
		["You", "W-W--What ?? Another well already ? What the hell are you doing ! Can’t you see that you are creating trouble in the valley ?"],
		["Deeper", "Ahah ! This earthquakes were already tharr, or not tharr exactly but in anothah plane of existence, it’s okay ! How in dah world making pretty tiny holes deep down could disrupt the geological balance ?"],
		["You", "Wow you speak so smart. I am convinced. You have used great wisdom in your speech. I will go straight back home."],
	], 3, 15)
	yield(get_tree().create_timer(3.3), "timeout")
	$Player.anim($Player.ANIMATION_ANGRY)
	
# dream 2
func next16():
	$Transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	$Maison.animation = "dream2"
	$Maison/In.hide()
	$Maison/Out.hide()
	$Player.hide()
	showDialogue([
		["???", "Quaaack, Quaaaack !"],
	], 2, 16)
	
func next17():
	$Transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	$Maison.animation = "maison"
	$Maison/In.show()
	$Maison/Out.hide()
	$Player.show()
	$Player.flipH(false)
	
	$Player.anim($Player.ANIMATION_MEAL)
	$Player.setPosition($Player.positionMeal)
	$Player.show()
	$Camera.reset()
	$Maison/In/Trape/AnimatedSprite.animation = "close"
	showDialogue([
		["You", "This weird dream again... This time, it was much more understandable... Yum"],
	], 1, 17)

func next18():
	$Camera.small_shake()
	showDialogue([
		["You", "Wha… Again ! Oh no the shelf !"],
	], 2.5, 18)
	next19NbQteLeft = 4

var next19NbQteLeft
func next19():
	$Camera.zoomInAndMove(Vector2(-100, -50), Vector2(0.40, 0.40), 2, 0)
	$Player.move($Player.positionShelf, 1, 0.1)
	$Player.anim($Player.ANIMATION_RUN)
	$Maison/In/Shelf.fallBook()
	q = Qte.instance()
	$Camera/Camera2D/QteLayer.add_child(q)
	q.connect("end", self, "on_qte_end_19")	
	q.start(null, 1.5, 0.2)
	$Camera/Camera2D/ScreenShake.start(1.2, 8, 10, 1)
	yield(get_tree().create_timer(1.1), "timeout")
	$Player.anim($Player.ANIMATION_ANGRY)

func on_qte_end_19(success):
	$Camera/Camera2D/ScreenShake._reset()
	$Camera/Camera2D/QteLayer.remove_child(q)
	$Maison/In/Shelf.finLivreTombe()
	yield(get_tree().create_timer(0.2), "timeout")
	print("next19NbQteLeft ", next19NbQteLeft)
	if success:
		if next19NbQteLeft <= 1:
			next20()
		else:
			next19NbQteLeft -= 1
			next19()
	else: fail19()

func fail19():
	$Maison/In/Shelf.reset()
	fail()
	showDialogue([
		["~~~", "GAME OVER"],
	], 1, 19)

func next20():
	$Camera.reset()
	$Maison/In/Shelf.reset()
	$Player.anim($Player.ANIMATION_HAPPY)
	showDialogue([
		["You", "Phew..."]
	], 1, 20)
	pass

# dehors 3
func next21():
	$Player.flipH(true) # tourne vers la gauche
	$Player.anim($Player.ANIMATION_RUN)	
	$Player.move($Player.positionPorte, 1, 0)
	$Transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	# dehors
	$Maison.animation = "dehors2"
	$Maison/In.hide()
	$Maison/Out.show()
	$Player.show()
	$Player.setPosition($Player.positionFleur)
	$Player.anim($Player.ANIMATION_ANGRY)
	showDialogue([
		["You", "Enough ! You have almost killed my flower, my fish and now my books !"],
		["Deeper", "Books cannot die."],
		["You", "You’re right… BUT ! Stop messing with the under..."],
		["Deeper", "Wait a minute please, lemme push dah button !"],
		["You", "A butt.."],
	], 1, 21)

func next22():
	$Camera/Camera2D/ScreenShake.start(2, 8, 100, 2)
	showDialogue([
		["You", "I knew it ! You were the one provoking them all from the beginning !"],
	], 3, 22)
	next23NbQteLeft = 3
	next23SideQte = true

var next23NbQteLeft
var next23SideQte
var goutte
func next23():
	goutte = Goutte.instance()
	q = Qte.instance()
	$Camera/Camera2D/QteLayer.add_child(q)
	self.add_child(goutte)
	goutte.position = $Player.positionCave + Vector2(0, -450)
	if (next23SideQte):
		goutte.fall(Vector2($Player.positionFleur + Vector2(0, 300)))
	else:
		goutte.fall(Vector2($Player.positionFleur + Vector2(-150, 350)))
	q.connect("end", self, "on_qte_end_23")	
	q.start(null, 1.8, 0.2)
	$Camera/Camera2D/ScreenShake.start(1.2, 8, 10, 1)
	yield(get_tree().create_timer(1.1), "timeout")

func on_qte_end_23(success):
	$Camera/Camera2D/ScreenShake._reset()
	$Camera/Camera2D/QteLayer.remove_child(q)
	if success:
		$Player.anim($Player.ANIMATION_RUN)
		if (next23SideQte):
			$Player.flipH(true)
			$Player.move($Player.positionFleur + Vector2(-150, 0), 0.5, 0)
		else:
			$Player.flipH(false)
			$Player.move($Player.positionFleur, 0.5, 0)
		next23SideQte = !next23SideQte
		yield(get_tree().create_timer(0.5), "timeout")
		$Player.anim($Player.ANIMATION_ANGRY)
		if next23NbQteLeft <= 1:
			next24()
		else:
			next23NbQteLeft -= 1
			next23()
	else: fail23()

func fail23():
	fail()
	showDialogue([
		["~~~", "GAME OVER"],
	], 1, 23)

func next24():
	$Player.anim($Player.ANIMATION_ANGRY)
	showDialogue([
		["You", "It was... Exhausting... I don’t feel so good... I was so close from dying… I should... go back to bed..."],
		["Deeper", "Yaaar, have a good night little neighbah !"],
	], 1, 24)

# dream 3
func next25():
	$Transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	$Maison.animation = "dream3"
	$Maison/In.hide()
	$Maison/Out.hide()
	$Player.hide()
	showDialogue([
		["???", "Qwack !"],
		["You", "You again !"],
		["You", "Oh, I can see clearly now. What are… A Dodo ! You are a Dodo !"],
		["???", "Qwack !"],
		["You", "Deepar is your name ? That is a strange name..."],
		["Deepar", "Qwack."],
		["You", "Yeah it was mean sorry... But I don’t understand, why are you appearing in all my dreams ?"],
		["Deepar", "Qwack ?"],
		["You", "Yes i’m fine, I guess, i don’t understand your point here ?"],
		["Deepar", "Qwack !"],
		["You", "Deeper Industries are really frightening me yes, but what can I do ?"],
		["Deepar", "Qwack Qwack !"],
		["You", "This world will die someday... Why are you telling me this !"],
		["Deepar", "Qwack."],
		["You", "If I cannot live properly, why everyone should..."],
		["Deepar", "QWACK !"],
		["You", "YES !"],
		["You", "I will end my suffer here you are right ! Let’s grab my fork and stop my neighbour ! He, and everyone will pay to make us suffer ! Let’s end this world !"],
	], 2, 25)

func next26():
	$Transition.transition()
	yield(get_tree().create_timer(1), "timeout")

	$Maison.animation = "maison"
	$Maison/In.show()
	$Maison/Out.hide()
	$Player.show()
	$Player.flipH(false)

	$Player.anim($Player.ANIMATION_MEAL)
	$Player.setPosition($Player.positionMeal)
	$Player.show()
	$Camera.reset()
	$Player.anim($Player.ANIMATION_RUN)
	$Player.move($Player.positionCave, 2, 0)
	yield(get_tree().create_timer(2), "timeout")
	$Player.hide()
	$Maison/In/Trape/AnimatedSprite.animation = "open"
	yield(get_tree().create_timer(1.5), "timeout")
	$Maison/In/Trape/AnimatedSprite.animation = "close"
	$Player.show()
	$Player.anim($Player.ANIMATION_RUN_FORK)
	$Player.flipH(true)
	$Player.move($Player.positionPorte, 3, 0)
	yield(get_tree().create_timer(2.5), "timeout")
	$Transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	# dehors
	$Maison.animation = "dehors2"
	$Maison/In.hide()
	$Maison/Out.show()
	$Player.setPosition($Player.positionFleur)
	$Player.anim($Player.ANIMATION_ANGRY_FORK)
	showDialogue([
		["Deeper", "Wait, little neighbah ? What are you doing with this ? No ! You can’t throw this in the well... Stop it already !"],
	], 2, 26)

func next27():
	$Camera.zoomInAndMove($Player.positionFleur + Vector2(-30, 0), Vector2(0.45, 0.45), 2, 0)
	$Player.anim($Player.ANIMATION_THROW_1)
	q = Qte.instance()
	$Camera/Camera2D/QteLayer.add_child(q)
	q.connect("end", self, "on_qte_end_27")	
	q.start("ui_up", 99999, 0.5)

func on_qte_end_27(success):
	$Camera/Camera2D/QteLayer.remove_child(q)
	$Player.anim($Player.ANIMATION_THROW_2)
	yield(get_tree().create_timer(0.2), "timeout")
	$Camera.reset()
	var tnt = TNT.instance()
	self.add_child(tnt)
	tnt.position = $Player.positionFleur + Vector2(-50, -70)
	tnt.move($Player.positionPuit, PI*-15)

