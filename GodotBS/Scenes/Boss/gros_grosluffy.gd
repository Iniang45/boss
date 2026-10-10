extends CharacterBody2D


var vecteurX = 90
var vecteurY = 0
var invincible = false
var VieBoss = 100
var angle = 0
signal collide(body_name)
var _last_collided_body: Node2D = null
func _ready():
	velocity.x = vecteurX
	$AnimatedSprite2D.animation = "idle"

func _physics_process(delta):
	$AnimatedSprite2D.play()
	move_and_slide()
	emission_collision()
	
	velocity.x = vecteurX*3
	velocity.y = vecteurY*3
	var limit = Vector2(40,30)
	var limitU  = Vector2(1125,624)
	position = position.clamp(limit,limitU)
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
		$AnimatedSprite2D.modulate = Color(1, 0, 0) # rouge
		await get_tree().create_timer(0.3).timeout
		$AnimatedSprite2D.modulate = Color(1, 1, 1) # couleur normale
		invincible = false
		
func restart():
	VieBoss = 100
func desactiver(booleen):
	if booleen:
		visible = false
		$CollisionShape2D.disabled = true
	else:
		visible = true
		$CollisionShape2D.disabled = false
func emission_collision() -> void:
	var current_collision_body: Node2D = null

	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		current_collision_body = collision.get_collider() as Node2D

		# Si un nouvel objet est percuté
		if current_collision_body != null and current_collision_body != _last_collided_body:
			_last_collided_body = current_collision_body
			
			# Émission du signal avec le nom du nœud
			collide.emit(current_collision_body.name)
			print("Collision avec : ", current_collision_body.name)

	# Si le boss ne touche plus rien, on réinitialise pour le prochain impact
	else:
		_last_collided_body = null
