extends Area2D

# Récupération du nœud de collision (en respectant l'orthographe "collsion")
@onready var collsion: CollisionPolygon2D = $Collision
# Si tu utilises un AnimatedSprite2D enfant :
@onready var sprite: AnimatedSprite2D = $SlashSprite


func _ready() -> void:
	# Désactivé et masqué par défaut au lancement
	activerSlash(false)


## Active ou désactive le slash (visuel + collision)
func activerSlash(actif: bool) -> void:
	visible = actif
	# set_deferred évite les avertissements du moteur lors des modifications de physique
	collsion.set_deferred("disabled", not actif)
	
	if actif and sprite:
		sprite.play("Blue_slash")


## Miroir sur l'axe vertical (inverse aussi la zone de collision)
func flip_vertical(flip: bool) -> void:
	if flip:
		scale.y = -1.0
	else : 
		scale.y = 1.0
