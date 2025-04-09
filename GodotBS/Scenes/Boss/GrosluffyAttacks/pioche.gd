extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func reverse():
	$piocheSprite.flip_h = true
	$piocheCollision.disabled = true
	$piocheCollisionReverse.disabled = false 
func normal():
	$piocheSprite.flip_h = false
	$piocheCollision.disabled = false
	$piocheCollisionReverse.disabled = true 
