extends StaticBody2D
@onready var Ray = $RayCast2D
@onready var dialogue = $Bulle/Label
@onready var timer = $Bulle/BulleTimer
var phrases = ["va chercher connars","ouga ouga  ","non dawg t'es cooked"]
var fini = false
var dialogueStart = false
signal ilParle
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#Aller voir clement.gd même code
	if Input.is_action_just_pressed("interact"):
		
		if Ray.is_colliding():
			$AnimatedSprite2D.play("idle")
			if not dialogueStart : 
				ilParle.emit()
				timer.start()
				dialogueStart = true 
	if fini:
				$AnimatedSprite2D.stop()



func _on_bulle_timer_timeout():
	fini = true
