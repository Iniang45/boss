extends Control
var camx = 576
var camy = 1995
@onready var animation = $AnimationPlayer
@onready var narrateur = $TileMap/Narrateur
@onready var grosluffy = $TileMap/Grosluffy/Corps
var transfo = false
signal animfini 
# Called when the node enters the scene tree for the first time.
func _ready():
	grosluffy.flip_h = true
func _process(delta):
	if  animation.get_current_animation()!="":
		var moment = animation.current_animation_position
		if $TileMap/Narrateur/LabelContainer.visible == true: 
			narrateur.play("talk")
		else : 
			narrateur.play("idle")
		if transfo == false :
			if  moment <=10.5 and  moment >= 8: 
				grosluffy.play("luffy")
		
			else:
				grosluffy.play("luffy_idle")
		else : 
			grosluffy.play("grosluffy")
func _on_grosluffy_body_change():
	transfo = true
func lancement():
	$AnimationPlayer.play("RESET")

func grosluffyFlip():
	grosluffy.flip_h = true
func _on_animation_player_animation_finished(anim_name):
	animfini.emit()
