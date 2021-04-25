extends Node2D

onready var livres = [$Book, $Book2, $Book3, $Book4]
onready var livresRestant = livres.duplicate()
var livreTombe

func _ready():
	pass

# fait tomber un livre
func fallBook():
	livreTombe = livresRestant.pop_back()
	livreTombe.fall()

func finLivreTombe():
	livreTombe.hide()

func reset():
	for livre in livres:
		# reset position livre
		livre.reset()
		livre.show()
	livresRestant = livres.duplicate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
