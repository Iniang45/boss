extends Control
signal ilSortDebut
signal ramasse
signal ilaclick
var peutsortir = false
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


func _on_pise_ilaparle():
	lesSoisfranc(true)
	print("ll")
