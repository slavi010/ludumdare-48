extends Node2D


var Qte = load("res://qte/qte.tscn")
var Dialogue = load("res://UI/Dialogue.tscn")
var Planche = load("res://object/Planche/Planche.tscn")
var Goutte = load("res://object/Goutte/Goutte.tscn")
var TNT = load("res://object/TNT/TNT.tscn")
var ButtonUp = load("res://UI/ButtonUp.tscn")

var q

var etape: float = 0
var dialogue = null
var buttonUp


func menu():
	$Maison/In.hide()
	$Maison/Out.hide()
	$Player.hide()
	
	$Maison.animation = "menu"
	
	buttonUp = ButtonUp.instance()
	self.add_child(buttonUp)
	buttonUp.position = Vector2(0, 200)
	buttonUp.connect("menu_end", self, "_on_ButtonUp_menu_end")
	
	

func _on_ButtonUp_menu_end():
	buttonUp.hide()
	self.remove_child(buttonUp)
	buttonUp = null
	next0()
	


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
	menu()
#	next27()

# max 30 sec
func sond(path: String):
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load("res://sounds/"+path)
	(player.stream as AudioStreamOGGVorbis).set_loop(false)
	player.volume_db = 0.3
	player.play()
	yield(get_tree().create_timer(30), "timeout")
	self.remove_child(player)
	

func fail():
	sond("other_fx/noooo3s.ogg")
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
	$Earth.hide()
	$Maison.animation = "maison"
	$Maison/In.show()
	$Maison/Out.hide()
	$Maison/In/FlowerPot.reset()
	$Maison.show()
	$Player.flipH(false)
	$Player.show()
	$Player.anim($Player.ANIMATION_MEAL)
	$Player.setPosition($Player.positionMeal)
	$Maison/In/Fish/AnimatedSprite.animation = "normal"
	$Maison/In/FlowerPot/AnimatedSprite.animation = "normal"
	# print dialogue delay 2sec	
	showDialogue([
		["~~~", "In the tranquil valley of gymnopedia...","other_fx/narrateur1.ogg"],
	], 1, 0)

func next0_1():
	sond("other_fx/tremblement faible2s.ogg")
	$Camera.small_shake()
	
	showDialogue([
		["~~~", "In the less tranquil valley of gymnopedia...","other_fx/narrateur2.ogg"],
		["You", "What the.... Why is my house so giggly all of a sudden ?","main/main1.ogg"],
		["You", "Wait ! No my flower pot !","main/main2.ogg"]
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
	sond("other_fx/craquefleur.ogg")
	showDialogue([
		["~~~", "GAME OVER"],
	], 1, 1)
	

# affiche dialogue "I got you"
func next2():
	
	$Player.anim($Player.ANIMATION_ANGRY)
	sond("other_fx/pose fleur.ogg")
	showDialogue([
		["You", "I got you ! No need to tremble anymore my pretty flower !","main/main3.ogg"],
		["You", "What’s going on ? ","main/main4.ogg"]
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
		["You", "Wooohaaaaaat ???","main/main5.ogg"],
		["Deeper", "Hey little neighbah ! I’ve just installed mah cutie farm  next to yarr house ! Look how mah plant is growing  !","deeper/deeper1.ogg"],
		["You", "(I don’t think we talk about the same plants...)"],
		["Deeper", "Yaaaa look at this little neighbah ! This baby can drill more than 3 miles deep !","deeper/deeper2.ogg"],
		["You", "I’m not sure it is a good idea to go deeper and deeper...","main/main6.ogg"],
		["Deeper", "Errr, Togethah, at Deeper Industries, we do not need to say dah theme in our dialogues to make a game linked with this yerr's theme !","deeper/deeper3.ogg"],
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
		["You", "What a strange dream...","main/main7.ogg"],
		["You", "Nevermind, with all the mess Mr.DrillGuy is making, I shall find a solution to protect my flower.","main/main8.ogg"],
		["You", "Let’s find my tools !","main/main9.ogg"]
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
	sond("other_fx/ouvertureTrappe.ogg")
	$Camera/Camera2D/ScreenShake.start(1, 2, 60, 2)
	showDialogue([
		["You", "Woah it’s pretty dark in here !","main/main10.ogg"],
		["You", "Okay let’s create the perfect fall proof flower pot","main/main11.ogg"],
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
	q.start(null, 3, 0)
	$Camera/Camera2D/ScreenShake.start(1.2, 8, 10, 1)
	if next8NbQteLeft == 4:
		sond("other_fx/qteCave.ogg")

func on_qte_end_8(success):
	$Camera/Camera2D/ScreenShake._reset()
	$Camera/Camera2D/QteLayer.remove_child(q)
	$Camera/Camera2D/QteLayer.remove_child(planche)
	yield(get_tree().create_timer(0.3), "timeout")
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
		["You", "Phew, that was quite the work ! Well yeah, I could have turned the light on, but it would have been less fun !","main/main12.ogg"],
		["You", "And here is the protectaflower 2000 ! With this, no more earthquake hazards !","main/main13.ogg"],
	], 1, 9)
	
# its work
func next10():
	yield(get_tree().create_timer(1), "timeout")
	sond("other_fx/tremblement faible2s.ogg")
	$Camera.small_shake()
	showDialogue([
		["You", "It’s working ! ","main/main14.ogg"],
		["You", "Rose are red, Violets are blue and nothing bad will happen to me and you !","main/main15.ogg"],
	], 1, 10)
	

# crack
func next11():
	$Maison/In.show()
	$Maison/Out.hide()
	$Player.show()
	$Camera.reset()
	$Player.setPosition($Player.positionCave)
	$Player.anim($Player.ANIMATION_HAPPY)
	$Maison.animation = "maison"
	sond("other_fx/crac aquariumx3.ogg")
	yield(get_tree().create_timer(1), "timeout")
	$Player.anim($Player.ANIMATION_ANGRY)
	print("crack")
	showDialogue([
		["You", "Cracks ? What do you mean cracks !?","main/main16.ogg"],
	], 2, 11)

# crack again
func next12():
	yield(get_tree().create_timer(1), "timeout")
	sond("other_fx/crac aquariumx3.ogg")
#	dynplayer.play()
	print("crack")
	$Maison/In/Fish/AnimatedSprite.animation = "fissure"
	showDialogue([
		["You", "Maurice the fish is in danger ! I have to help it ! That clearly is a flex tape situation.","main/main17.ogg"],
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
	sond("other_fx/flextap.ogg")
	yield(get_tree().create_timer(0.7), "timeout")
	$Maison/In/Fish/AnimatedSprite.animation = "flextape"
	$Player.anim($Player.ANIMATION_HAPPY)
	showDialogue([
		["You", "Good old flex tape... Can fix any situations... I guess ? ","main/main18.ogg"],
		["You", "No it cannot fix my neighbor, but I can fix him.","main/main19.ogg"],
	], 1, 14)

func next15():
	$Player.flipH(true) # tourne vers la gauche
	$Player.anim($Player.ANIMATION_WALK)	
	$Player.move($Player.positionPorte, 2, 0.1)
	yield(get_tree().create_timer(1.1), "timeout")
	$Transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	# dehors
	$Maison.animation = "dehors"
	$Maison/In.hide()
	$Maison/Out.show()
	$Player.setPosition($Player.positionFleur)
	$Player.move($Player.positionInit, 3, 0.3)
	showDialogue([
		["You", "W-W--What ?? Another well already ? What the hell are you doing ! Can’t you see that you are creating trouble in the valley ?","main/main20.ogg"],
		["Deeper", "Ahah ! This earthquakes were already tharr, or not tharr exactly but in anothah plane of existence, it’s okay !","deeper/deeper4.ogg"], 
		["Deeper", "How in dah world making pretty tiny holes deep down could disrupt the geological balance ?","deeper/deeper5.ogg"],
		["You", "Wow you speak so smart. I am convinced. You have used great wisdom in your speech. I will go straight back home.","main/main21.ogg"],
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
		["???", "Quaaack, Quaaaack !","qwak/qwak9.ogg"],
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
		["You", "This weird dream again... This time, it was much more understandable...","main/main22.ogg"],
	], 1, 17)

func next18():
	sond("other_fx/tremblement faible2s.ogg")
	$Camera.small_shake()
	showDialogue([
		["You", "Wha... Again ! Oh no the shelf !","main/main23.ogg"],
	], 2.5, 18)
	next19NbQteLeft = 4

var next19NbQteLeft
func next19():
	$Camera.zoomInAndMove(Vector2(-100, -50), Vector2(0.40, 0.40), 2, 0)
	$Player.move($Player.positionShelf, 1, 0.1)
	$Player.anim($Player.ANIMATION_RUN)
	$Maison/In/Shelf.fallBook()
	
	#sond book
	match next19NbQteLeft:
		4: sond("other_fx/livre1.ogg")
		3: sond("other_fx/livre2.ogg")
		2: sond("other_fx/livre3.ogg")
		1: sond("other_fx/livre4.ogg")
	
	q = Qte.instance()
	$Camera/Camera2D/QteLayer.add_child(q)
	q.connect("end", self, "on_qte_end_19")	
	q.start(null, 1, 0.2)
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
	sond("main/phew.ogg")
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
		["You", "Enough ! You have almost killed my flower, my fish and now my books !","main/main23.ogg"],
		["Deeper", "Books cannot die.","deeper/deeper6.ogg"],
		["You", "You’re right… BUT ! Stop messing with the under...","main/main24.ogg"],
		["Deeper", "Wait a minute please, lemme push dah button !","deeper/deeper7.ogg"],
		["You", "A butt..","main/main25.ogg"],
	], 1, 21)

func next22():
	sond("other_fx/tremblement moyen.ogg")
	$Camera/Camera2D/ScreenShake.start(2, 8, 100, 2)
	showDialogue([
		["You", "I knew it ! You were the one provoking them all from the beginning !","main/main27.ogg"],
	], 3, 22)
	next23NbQteLeft = 6
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
	q.start(null, 0.6, 0.2)
	#sond goutte
	match next23NbQteLeft:
		6: sond("other_fx/livre1.ogg")
		5: sond("other_fx/livre2.ogg")
		4: sond("other_fx/livre3.ogg")
		3: sond("other_fx/livre4.ogg")
		2: sond("other_fx/livre1.ogg")
		1: sond("other_fx/livre2.ogg")
	$Camera/Camera2D/ScreenShake.start(0.8, 8, 10, 1)
	yield(get_tree().create_timer(1.1), "timeout")

func on_qte_end_23(success):
	$Camera/Camera2D/ScreenShake._reset()
	$Camera/Camera2D/QteLayer.remove_child(q)
	if success:
		$Player.anim($Player.ANIMATION_RUN)
		if (next23SideQte):
			$Player.flipH(true)
			$Player.move($Player.positionFleur + Vector2(-150, 0), 0.3, 0)
		else:
			$Player.flipH(false)
			$Player.move($Player.positionFleur, 0.3, 0)
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
		["You", "It was... Exhausting... I don’t feel so good... I was so close from dying… I should... go back to bed...","main/main26.ogg"],
		["Deeper", "Yaaar, have a good night little neighbah !","deeper/deeper8.ogg"],
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
		["???", "Qwack !","qwak/qwak1.ogg"],
		["You", "You again !","main/main25.ogg"],
		["You", "Oh, I can see clearly now. What are… A Dodo ! You are a Dodo !","main/main29.ogg"],
		["???", "Qwack !","qwak/qwak8.ogg"],
		["You", "Deepar is your name ? That is a strange name...","main/main28.ogg"],
		["Deepar", "Qwack.","qwak/qwak2.ogg"],
		["You", "Yeah it was mean sorry... But I don’t understand, why are you appearing in all my dreams ?","main/main30.ogg"],
		["Deepar", "Qwack ?","qwak/qwak3.ogg"],
		["You", "Yes i’m fine, I guess, i don’t understand your point here ?","main/main31.ogg"],
		["Deepar", "Qwack !","qwak/qwak4.ogg"],
		["You", "Deeper Industries are really frightening me yes, but what can I do ?","main/main32.ogg"],
		["Deepar", "Qwack Qwack !","qwak/qwak5.ogg"],
		["You", "This world will die someday... Why are you telling me this !","main/main33.ogg"],
		["Deepar", "Qwack.","qwak/qwak6.ogg"],
		["You", "If I cannot live properly, why everyone should...","main/main22.ogg"],
		["Deepar", "QWACK !","qwak/qwak7.ogg"],
		["You", "YES ! I will end my suffer here you are right ! Let’s grab my fork and stop my neighbour ! He, and everyone will pay to make us suffer ! Let’s end this world !","main/main34.ogg"],
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
	sond("other_fx/ouvertureTrappe.ogg")
	yield(get_tree().create_timer(1.5), "timeout")
	$Maison/In/Trape/AnimatedSprite.animation = "close"
	sond("other_fx/ouvertureTrappe.ogg")
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
		["Deeper", "Wait, little neighbah ? What are you doing with this ? No ! You can’t throw this in the well... Stop it already !","deeper/deeper9.ogg"],
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
	# boom
	yield(get_tree().create_timer(2), "timeout")
	$Maison/In.hide()
	$Maison/Out.hide()
	$Player.hide()
	$Maison.animation = "boom"
	sond("other_fx/tremblement moyen3s.ogg")
	tnt.hide()
	self.remove_child(tnt)
	yield(get_tree().create_timer(1), "timeout")
	$Transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	$Maison.animation = "etoile"
	# afficher terre
	$Earth.show()
	$Earth.animation = "nuke"
	yield(get_tree().create_timer(2), "timeout")
	$Earth.animation = "crack"
	sond("other_fx/pop.ogg")
	yield(get_tree().create_timer(1.5), "timeout")
	$Earth.animation = "split"
	sond("dorime.ogg")
	$FinDodo.show()
	yield(get_tree().create_timer(6), "timeout")
	
	# crédit
	buttonUp = ButtonUp.instance()
	self.add_child(buttonUp)
	buttonUp.position = Vector2(0, 200)
	buttonUp.connect("menu_end", self, "credit")

# THE END
func credit():
	sond("aaaaa.ogg")
	$Earth.hide()
	$FinDodo.hide()
	$Maison.animation = "credit"
	
	buttonUp.hide()
	self.remove_child(buttonUp)
	buttonUp = null
	

	yield(get_tree().create_timer(4), "timeout")
	buttonUp = ButtonUp.instance()
	buttonUp.hide()
	self.add_child(buttonUp)
	buttonUp.position = Vector2(0, 200)
	buttonUp.connect("menu_end", self, "restart")

func restart():
	buttonUp.hide()
	self.remove_child(buttonUp)
	buttonUp = null
	menu()


