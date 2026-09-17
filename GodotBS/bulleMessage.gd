extends Control
@export var image =""
@export var phrase = []
signal dialoguelance 
@onready var text = $bulle/label
@onready var perso = $bulle/perso
var indicePhrase = 0
signal dialoguefini
# Called when the node enters the scene tree for the first time.
func _ready():
	perso.texture = load(str(image))
	text.text = phrase[0]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(phrase) >= 2:
		if Input.is_action_just_pressed("interact"):
			nextText()
func initialiser(phrases,imagePerso):
	phrase = phrases
	image = imagePerso
	

func nextText():
	if text.text == phrase[-1]:
		dialoguefini.emit()
		return
	text.text = phrase[indicePhrase]
	indicePhrase +=1 
	
	
func desactiver(booleen):
	if booleen:
		visible = false 
	else:
		visible = true

func _on_dialoguelance():
	desactiver(false)
	text = phrase[0]
	print(text)


func _on_dialoguefini():
	print("c'est pas fini")
	queue_free()
