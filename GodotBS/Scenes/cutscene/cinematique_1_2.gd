extends Control
var camx = 576
var camy = 2835
var pos_camx = 2900
var pos_camy = 350
@onready var animation = $AnimationPlayer
@onready var narrateur = $TileMap/Narrateur
@onready var grosluffy = $TileMap/Grosluffy/Corps
var transfo = false
var passCinema = false
signal animfini2 
signal animfiniMort
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _process(delta):
	if animation.get_current_animation() != "":
		if  animation.get_current_animation()=="phase":
			var moment = animation.current_animation_position
			
			if $TileMap/Narrateur/LabelContainer.visible == true: 
				narrateur.play("talk")
			else : 
				narrateur.play("idle")
			if  moment <=1 and  moment >= 0: 
				grosluffy.play("grosluffy")
			
			else:
				grosluffy.play("luffy_idle")
		else:
			var moment = animation.current_animation_position
			
			if $TileMap/Narrateur/LabelContainer.visible == true: 
				narrateur.play("talk")
			else : 
				narrateur.play("idle")
			if  moment <=9 : 
				grosluffy.play("luffy_damaged")
			
			else:
				grosluffy.play("luffy")
func lancement(cine):
	$AnimationPlayer.play(cine)


func _on_animation_player_animation_finished(anim_name):
	print(anim_name)
	if not passCinema and anim_name =="phase": 
		
		animfini2.emit()
		$AnimationPlayer.play("RESET")
	if anim_name == "fin":
		animfiniMort.emit()
	


func _on_button_pressed():
	if animation.get_current_animation() =="fin":
		animfiniMort.emit()
	else:
		
		animfini2.emit()
		passCinema = true
