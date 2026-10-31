extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	$Collision.disabled = false
	$Collision2.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible and $SlashSprite.frame > 2 :
		$Collision.disabled = true 
	else :
		pass
