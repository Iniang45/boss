extends CharacterBody2D
#Cf soisfranc.gd
var invincible = false
var VieBoss = 100
signal bodyChange 
signal toucheBoss2
signal toucheDawg
var angle = 0
enum direction {hautG, basG, hautD, basD}
enum states {idle, attackLeft,attackRight, deplacement}
var state : states = states.idle
var directionState : direction = direction.hautG
@onready var  slashcolli1 = $Slash/CollisionSlash
@onready var slashcolli2 = $Slash2/CollisionSlash

const SPEED = 300.0
var nbanimfini = 0 
var animfiniL = false
var animfiniR = false
var flip = false
var pause = true 
func ready():
	collisioGestion2(true)
	collisionGestion1(true)

func _physics_process(delta):
	phase1()
	#Permet au boss de ne pas toucher pendant les cinématiques
	if pause:
		velocity = Vector2.ZERO
	$YlhanSprite.flip_h = flip
	move_and_slide()
	var limit = Vector2(40,30)
	var limitU  = Vector2(1155,624)
	#Permet au boss de pas sortir de la fenêtre
	position = position.clamp(limit,limitU)
func phase1():
	#print($YlhanSprite.animation)
	#print(state)
	#$YlhanSprite.animation = "walk"
	#Définition de la machine à états de la même manière que dans le fichier soisfranc.gd
	match state:
		states.idle:
			deplacement()
			$YlhanSprite.play("idle")
			await get_tree().create_timer(1).timeout
			
			state = states.deplacement
		states.attackLeft:
	
			velocity = Vector2.ZERO
			if not animfiniL: 
				#print("statejj")
				if $YlhanSprite.animation != "attack_right":
					$YlhanSprite.play("attack_left")
					if $YlhanSprite.frame > 2:
						collisionGestion1(false)
			if not $YlhanSprite.is_playing():
				state = states.idle
				animfiniL = false
			
		states.attackRight:
			velocity = Vector2.ZERO
			if not animfiniR: 
				#print("statejj")
				if $YlhanSprite.animation != "attack_left":
					$YlhanSprite.play("attack_right")
					if $YlhanSprite.frame > 2:
						collisioGestion2(false)
			if not $YlhanSprite.is_playing():
				state = states.idle
				animfiniR = false
					
		states.deplacement:
			deplacement()

			await get_tree().create_timer(2).timeout

			var randattack = randi_range(1,2)
			match randattack:
				1:
					state = states.attackRight
				2:
					state = states.attackLeft
func _on_ylhan_sprite_animation_finished():
	match $YlhanSprite.animation : 
		"attack_left":
			collisionGestion1(true)
			animfiniL = true
			print("ca faire mal")
		"attack_right":
			collisioGestion2(true)
			animfiniR = true 
func deplacement():
	#Fonction permettant au boss de se déplacer vers le joueur 
	match directionState:
		direction.hautG:
			velocity.y -= 1
			velocity.x -= 1
		direction.basG: 
			velocity.y += 1
			velocity.x -= 1
		direction.hautD :
			velocity.x += 1
			velocity.y -= 1
		direction.basD:
			velocity.x += 1
			velocity.y +=1
	#print(directionState)
	#print(angle)
	if velocity.length() > 0:
		velocity = velocity.normalized() * 100
		$YlhanSprite.play("walk")
		#print(directionState)
	
func collisioGestion2(booleen):
	#Fonction permettant la gestion des collisions des attaques
	$Slash2/CollisionSlash.disabled = booleen
	if booleen :
		$Slash2/CollisionSlash/RayCast2D.set_enabled(false)
	else:
		$Slash2/CollisionSlash/RayCast2D.set_enabled(true)
func collisionGestion1(booleen):
	$Slash/CollisionSlash.disabled = booleen
	if booleen :
		$Slash/CollisionSlash/RayCast2D.set_enabled(false)
	else:
		$Slash/CollisionSlash/RayCast2D.set_enabled(true)
func _on_corps_body_entered(body):
	#Signal émis lorsque le corps du boss touche le joueur 
	toucheDawg.emit()
