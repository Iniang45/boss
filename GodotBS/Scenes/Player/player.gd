extends CharacterBody2D

@export var speed = 200 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var screen_size_change
var direction = "up"
var ComboCount = 0
var peutCombo = false
var peutTp = true 
var health = 100
var invincible = false
var attaqueBase = 10.0
@onready var cam = $Node/Camera2D
signal tp
signal hit
var limit = Vector2(0,0) 
@onready var moi = $PlayerSprite
@onready var timeCombo = $PlayerSprite/AttackSprite/ComboTimer
@onready var attackTimer = $PlayerSprite/AttackTimer
@onready var tpTimer = $PlayerSprite/TpSprite/TpTimer
@onready var CollisionSlash = $Slash/CollisionSlash
@onready var moiCollision = $PlayerCollision
@onready var RayDark = $Slash/CollisionSlash/RayCast2D
@onready var vieVerte = $Transition/PlayerHB/HBvide/HB
@onready var vieBleu = $Transition/PlayerHB/HBvide/HB2
var cooldownAttack = false
func _ready():
	screen_size = get_viewport_rect().size
	screen_size_change = screen_size
	CollisionSlash.disabled = true
	calculClamp()
	RayDark.enabled = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var posY = moi.position.y
	var posX = moi.position.x
	#var velocity = Vector2.ZERO # The player's movement vector.
	velocity = Vector2.ZERO
	if Input.is_action_pressed("tp"):
		if peutTp: 
			$PlayerSprite/TpSprite/TpCooldown.start()
			peutTp = false
			vieBleu.visible = true 
			$PlayerSprite/TpSprite.visible = true 
			await get_tree().create_timer(0.1).timeout
			$PlayerSprite/TpSprite.visible = false
			match direction:
				"up" : 
					moi.position.y -= 85
					moiCollision.position.y -= 85
				"down":
					moi.position.y += 85
					moiCollision.position.y += 85
				"right":
					moi.position.x += 85
					moiCollision.position.x += 85
				"left":
					moi.position.x -=85
					moiCollision.position.x -= 85
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		direction = "right"
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		direction = "left"
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		direction = "down"
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		direction = "up"
	if Input.is_action_just_pressed("attack"):
		timeCombo.start()
		if attackTimer.is_stopped():
			$PlayerSprite/AttackSprite.play("slash_up")
			activationCollisions() 
		if peutCombo and ComboCount>0 : 
			$PlayerSprite/AttackSprite2.play("slash_down")
			activationCollisions()
			ComboCount=0
			timeCombo.stop()
			peutCombo = false
			attackTimer.stop()
		else:
			ComboCount +=1
			if attackTimer.is_stopped():
				attackTimer.start()
	if velocity.x > 0:
		$PlayerSprite.animation = "walk_right"

	elif velocity.x < 0:
		$PlayerSprite.animation = "walk_left"

	elif velocity.y > 0 :
		$PlayerSprite.animation = "walk_down"

	elif velocity.y < 0 : 
		$PlayerSprite.animation = "walk_up"
	else : 
		$PlayerSprite.animation = "idle_down"
		match direction :
			"up":
				$PlayerSprite.animation = "idle_up"
				$PlayerSprite/AttackSprite.rotation_degrees = 0
				$PlayerSprite/AttackSprite2.rotation_degrees = 180
				CollisionSlash.position.y = posY -48
				CollisionSlash.position.x = posX
				CollisionSlash.rotation_degrees = 90 
				
				
			"down":
				$PlayerSprite.animation = "idle_down"
				$PlayerSprite/AttackSprite.rotation_degrees = 128.6
				$PlayerSprite/AttackSprite2.rotation_degrees = 0
				CollisionSlash.position.y = posY + 48
				CollisionSlash.position.x = posX
				CollisionSlash.rotation_degrees = 90
				
			"right":
				$PlayerSprite.animation = "idle_right"
				$PlayerSprite/AttackSprite.rotation_degrees = 64.3
				$PlayerSprite/AttackSprite2.rotation_degrees = 270
				CollisionSlash.position.y = posY + 9 
				CollisionSlash.position.x = posX + 42
				CollisionSlash.rotation_degrees = 27.3
				
			"left":
				$PlayerSprite.animation = "idle_left"
				$PlayerSprite/AttackSprite.rotation_degrees = -100
				$PlayerSprite/AttackSprite2.rotation_degrees = 900
				CollisionSlash.rotation_degrees = -20
				CollisionSlash.position.y = posY + 9 
				CollisionSlash.position.x = posX - 42
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$PlayerSprite.play()
	
	else:
		$PlayerSprite.stop()
	
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print("I collided with ", collision.get_collider().name)

	#position += velocity*delta
	position = position.clamp(limit, screen_size_change)

	if timeCombo.time_left>0 and timeCombo.time_left < 1:
		
		peutCombo = true
	else : 
		peutCombo = false
	#RayDark.position=moi.position
	if RayDark.is_colliding() == true:
		hit.emit()
	vieBleu.size.x = vieVerte.size.x
	peutTaperAffichage()
func _on_tp_cooldown_timeout():
	peutTp = true
	vieBleu.visible=false 
func activationCollisions():
	CollisionSlash.disabled = false
	RayDark.enabled = true 		
	await get_tree().create_timer(0.2).timeout
	CollisionSlash.disabled = true
	RayDark.enabled = false  
func peutTaperAffichage() : 
	if attackTimer.is_stopped() == false and ComboCount>1: 
		$Transition/PlayerHB/PeutPasTaper.visible = true
	else:
		$Transition/PlayerHB/PeutPasTaper.visible = false
func hitMarker(degatsRecus):
	if not invincible :
		health-=degatsRecus
		
		match direction :
			"up":
				position.y += 100
			"down":
				position.y -=100
			"right":
				position.x -= 100
			"left":
				position.x += 100
		invincible = true
		$PlayerSprite/hitSprite.visible = true 
		await get_tree().create_timer(0.3).timeout
		$PlayerSprite/hitSprite.visible = false
		invincible = false
		var affichageDegats = degatsRecus*7800/100
		vieVerte.size.x = vieVerte.size.x- affichageDegats
		print(vieVerte.size.x)
		
func calculClamp():
	limit = Vector2(screen_size[0]*(int(cam.position.x/600)),screen_size[1]*(int(cam.position.y)/900)) 
	screen_size_change[0] = screen_size[0] + screen_size[0]*(int(cam.position.x)/600)
	screen_size_change[1] = screen_size[1] + screen_size[1]*(int(cam.position.y)/900)
	



