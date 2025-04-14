extends RigidBody2D

var velocity = Vector2.ZERO
var vecteurX = 90
var vecteurY = 0
var invincible = false
var VieBoss = 100

func _ready():
	velocity.x = vecteurX
	$AnimatedSprite2D.animation = "idle"

func _process(delta):
	$AnimatedSprite2D.play()
	set_linear_velocity(velocity)	
	velocity.x = vecteurX*3
	velocity.y = vecteurY*3
	#Réajustement des vecteurs car le boss pouvait se retrouver dans une boucle de rebonds
	if abs(vecteurX) < 50 and abs(vecteurY) <50 :
		var randdirection = randi_range(0,1)
		match randdirection : 
			0:
				if vecteurY > 0 :
					vecteurY = 200
				else:
					vecteurY = -200 
			1:
				if vecteurX > 0:
					vecteurX = 200
				else :
					vecteurX = -200

func hitMarker(degatsRecus):
	if not invincible :
		VieBoss-=degatsRecus
		invincible = true
		$hitSprite.visible = true 
		await get_tree().create_timer(0.3).timeout
		$hitSprite.visible = false
		invincible = false
		
