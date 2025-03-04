extends Control

@onready var animation = $AnimationPlayer
@onready var narrateur = $TileMap/Narrateur
@onready var grosluffy = $TileMap/Grosluffy/Corps
var transfo = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("RESET")
func _process(delta):
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
	print(grosluffy.animation)
func _on_grosluffy_body_change():
	transfo = true
