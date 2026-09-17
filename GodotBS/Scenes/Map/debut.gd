extends Control
signal ilSortDebut
signal ramasse
signal ilaclick
var peutsortir = false
var bulleDialogue = preload("res://Scenes/NPC/dialogue.tscn")
@onready var esma = $TileMap/Esma
@onready var clement =$TileMap/Clement
@onready var pise = $TileMap/Pise
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	
func _on_sortie_body_entered(body):
	ilSortDebut.emit()


func _on_cacamou_1_body_entered(body):
	ramasse.emit()
	print("caca")
	$Cacamou1/CollisionCaca.disabled = true
	$Cacamou1.queue_free()
	
func lesSoisfranc(visibleou):
	$Soisfranc1.visible = visibleou
	$Soisfranc2.visible = visibleou
	$Soisfranc3.visible = visibleou
	$Button1.visible = visibleou
	$Button2.visible = visibleou
	$Label.visible = visibleou


func _on_button_1_pressed():
	ilaclick.emit()
	peutsortir = true
	lesSoisfranc(false)


func _on_button_2_pressed():
	ilaclick.emit()
	peutsortir = true
	lesSoisfranc(false)


	


func _on_esma_il_parle():
	var new_instance = bulleDialogue.instantiate()
	new_instance.initialiser(esma.phrases, "res://Assets/NPC/Princess/nobg.png")
	add_child(new_instance)
	
	


func _on_clement_il_parle():
	var new_instance = bulleDialogue.instantiate()
	new_instance.initialiser(clement.phrases, "res://Assets/NPC/Clement/nobg.png")
	add_child(new_instance)


func _on_pise_il_parle():
	var new_instance = bulleDialogue.instantiate()
	new_instance.initialiser(pise.phrases, "res://Assets/NPC/Lise/nobg.png")
	add_child(new_instance)
	peutsortir = true
