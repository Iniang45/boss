extends Control
signal fini(name) 
var camx = 1764
var camy = 998
var phase = 1
@onready var cine = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$BossHealthBar/Label.text = "Ylhan,UFC"
	if cine.current_animation == "cinematique":
		if cine.current_animation_position <= 3: 
			$TileMap/Ylhan/YlhanSprite.play("walk")
	else:
		$TileMap/Ylhan/YlhanSprite.stop()
func lancement():
	match phase:
		1:
			$AnimationPlayer.play("cinematique")
		2: 
			$AnimationPlayer.play("phase2")

func _on_animation_player_animation_finished(anim_name):
	fini.emit(anim_name)
