extends Control
signal fini(name) 
var pos_camx = 1700
var pos_camy = 350
var phase = 1
@onready var cine = $AnimationPlayer
var passCinema = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$BossHealthBar/Label.text = "Ylhan,UFC"
	if cine.current_animation == "cinematique":
		if cine.current_animation_position <= 3: 
			$TileMap/Ylhan/Pivot/YlhanSprite.play("walk")
	else:
		$TileMap/Ylhan/Pivot/YlhanSprite.stop()
func lancement(cine):
	match phase:
		1:
			$AnimationPlayer.play("cinematique")
		2: 
			passCinema = false
			$AnimationPlayer.play("phase2")

func _on_animation_player_animation_finished(anim_name):
	if not passCinema : 
		fini.emit(anim_name)
	


func _on_button_pressed():
	fini.emit(cine.current_animation)
	passCinema = true
