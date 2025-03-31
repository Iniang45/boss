extends Control
var camx = 576
var camy = 2835
@onready var animation = $AnimationPlayer
@onready var narrateur = $TileMap/Narrateur
@onready var grosluffy = $TileMap/Grosluffy/Corps
var transfo = false
signal animfini2 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _process(delta):
	if  animation.get_current_animation()!="":
		var moment = animation.current_animation_position
		if $TileMap/Narrateur/LabelContainer.visible == true: 
			narrateur.play("talk")
		else : 
			narrateur.play("idle")
		if  moment <=1 and  moment >= 0: 
			grosluffy.play("grosluffy")
		
		else:
			grosluffy.play("luffy_idle")
func lancement():
	$AnimationPlayer.play("phase")


func _on_animation_player_animation_finished(anim_name):
	animfini2.emit()
