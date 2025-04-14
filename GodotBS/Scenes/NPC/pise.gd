extends StaticBody2D
@onready var Ray = $RayCast2D
@onready var dialogue = $Bulle/Label
var fini = false
signal ilaparle
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#aller voir clement.gd car même code
	if Input.is_action_just_pressed("interact"):
		
		if Ray.is_colliding():
			$AnimatedSprite2D.play("idle")
			dialogue.visible = true
			$Bulle.visible = true
			$Bulle/BulleTimer.start() 
		if $Bulle.visible and fini:
			$Bulle.visible = false
			fini = false
			ilaparle.emit()  
			print("zz")
			$AnimatedSprite2D.stop()
		if not Ray.is_colliding():
			$Bulle.visible = false
			$AnimatedSprite2D.stop()


func _on_bulle_timer_timeout():
	fini = true
