extends Area2D

@export var shoot_speed: float = 1000.0  # Vitesse de tir du bâton
@export var platform_scene: PackedScene  # Scène de la plateforme (bâton) une fois attachée

var velocity: Vector2 = Vector2.ZERO  # Vitesse du bâton
var stick_position: Vector2 = Vector2.ZERO  # Position du bâton
var is_attached: bool = false
var direction = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity.length() > 0:
		# Déplacer le bâton dans la direction
		stick_position += velocity * delta
		global_position = stick_position 

func shoot():
	visible =  true
	$CollisionShape2D.disabled = false
	velocity = direction * shoot_speed  # Appliquer la vitesse du tir
	stick_position = global_position  # Position initiale du tir 
	
