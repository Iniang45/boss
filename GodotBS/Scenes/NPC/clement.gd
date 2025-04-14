extends StaticBody2D
@onready var Ray = $RayCast2D
@onready var dialogue = $Bulle/Label
var fini = false
var phrases = ["aah grosluffy le prochain boss","il a la toonforce ! ","non dawg t'es cooked"]
var idphrases = 0
var dialoguefini = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#Programme permettant d'enchaîner les lignes de dialogue ainsi que de les arrêter si le joueur s'éloigne du PNJ
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
				await get_tree().create_timer(2).timeout
				dialogue.text = str(phrases[i])
				$AnimatedSprite2D.play("mini_idle")
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
	print("zigitouito")
