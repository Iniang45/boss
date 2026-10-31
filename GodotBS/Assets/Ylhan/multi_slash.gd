extends Area2D

@export var vitesse : float = 1000.0
var direction : Vector2 = Vector2.RIGHT

func _ready():
	$sprite.play("slash")
func _physics_process(delta: float) -> void:
	position += direction * vitesse * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	print("il est sorti")
	queue_free()
