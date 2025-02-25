extends StaticBody2D
@onready var Ray = $RayCast2D
@onready var dialogue = $Bulle/Label
var fini = false
var phrases = ["Waouh mais t'es le main character mdrr, ptits conseils :","Lorsque ta barre de vie est bleu tu peux plus esquiver","tant que les aiyans n'ont pas de limites, tu peux taper"]
# Called when the node enters the scene tree for the first time.
var dialoguefini = false
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("interact"):
		
		if Ray.is_colliding():
			$AnimatedSprite2D.play("idle")
			dialogue.visible = true
			$Bulle.visible = true
			$Bulle/BulleTimer.start() 
		if $Bulle.visible and fini:
			for i in range(len(phrases)):
				print(phrases[i])
				if dialoguefini:
					break
				$AnimatedSprite2D.play("idle_left")
				dialogue.text = str(phrases[i])
				await get_tree().create_timer(2).timeout
			$Bulle.visible = false
			dialoguefini = true
			fini = false 
			$AnimatedSprite2D.stop()
		if not Ray.is_colliding():
			$Bulle.visible = false
			$AnimatedSprite2D.stop()


func _on_bulle_timer_timeout():
	fini = true 
