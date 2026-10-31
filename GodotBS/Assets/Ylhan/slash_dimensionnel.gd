extends Control 
signal AnimationLancee
signal Touche
func _ready():
	visible = false
	$Node2D/AnimatedSprite2D.stop()
	$Node2D/Area2D/Collision.disabled = true 
	$Node2D/Area2D/Slash.stop()
func ActivateSlash(boolean):
	visible = boolean
	if boolean:
		$Node2D/AnimatedSprite2D.visible = true 
		$Node2D/AnimatedSprite2D.play("default")


func _on_animated_sprite_2d_animation_finished():
	$Node2D/Area2D.visible = true 
	$Node2D/Area2D/Slash.play("Slash")
	$Node2D/AnimatedSprite2D.visible = false 
	AnimationLancee.emit()


func _on_slash_animation_finished():
	$Node2D/Area2D/Collision.disabled = true 
	ActivateSlash(false)
	$Node2D/Area2D.visible = false
