extends StaticBody2D
@onready var Ray = $RayCast2D
@onready var dialogue = $Bulle/Label
@onready var timer = $Bulle/BulleTimer
var fini = false
var phrases = ["aah grosluffy le prochain boss","il a la toonforce ! ","non dawg t'es cooked"]
var idphrases = 0
var dialoguefini = false
# Called when the node enters the scene tree for the first time.
var dialogueStart = false
signal ilParle 
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
	
