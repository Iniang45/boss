extends CharacterBody2D
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
func ready():
	slashcolli1.disabled = true
	slashcolli2.disabled = true 

func _physics_process(delta):
	phase1()
	$YlhanSprite.flip_h = flip
	if $Slash2/CollisionSlash/RayCast2D.is_colliding() and $Slash2/CollisionSlash/RayCast2D.get_collider().name == "PlayerCollision":
		print()
		toucheDawg.emit()
	if $Slash/CollisionSlash/RayCast2D.is_colliding()  and $Slash/CollisionSlash/RayCast2D.get_collider().name == "PlayerCollision":
		toucheDawg.emit()
	if $Slash2/CollisionSlash/RayCast2D.is_colliding() and $Slash2/CollisionSlash/RayCast2D.get_collider().name != "Slash2":
		print($Slash2/CollisionSlash/RayCast2D.get_collider().name)
func phase1():
	#print($YlhanSprite.animation)
	#print(state)
	#$YlhanSprite.animation = "walk"
	
	match state:
		states.idle:
			
			$YlhanSprite.play("idle")
			await get_tree().create_timer(1).timeout
			var randattack = randi_range(1,2)
			match randattack:
				1:
					state = states.attackRight
				2:
					state = states.attackLeft
		states.attackLeft:
	
			
			if not animfiniL: 
				#print("statejj")
				if $YlhanSprite.animation != "attack_right":
					$YlhanSprite.play("attack_left")
					if $YlhanSprite.frame > 2:
						slashcolli1.disabled = false
			if not $YlhanSprite.is_playing():
				state = states.idle
				animfiniL = false
			
		states.attackRight:
			
			if not animfiniR: 
				#print("statejj")
				if $YlhanSprite.animation != "attack_left":
					$YlhanSprite.play("attack_right")
					if $YlhanSprite.frame > 2:
						slashcolli2.disabled = false
			if not $YlhanSprite.is_playing():
				state = states.idle
				animfiniR = false
					
		states.deplacement:
			pass

func _on_ylhan_sprite_animation_finished():
	match $YlhanSprite.animation : 
		"attack_left":
			slashcolli1.disabled = true
			animfiniL = true
			print("ca faire mal")
		"attack_right":
			slashcolli2.disabled = true 
			animfiniR = true 
func deplacement():
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
	
	


func _on_corps_body_entered(body):
	toucheDawg.emit()
