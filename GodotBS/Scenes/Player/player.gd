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
@onready var AreaSlash = $Slash
@onready var moiCollision = $PlayerCollision
@onready var RayDark = $Slash/CollisionSlash/RayCast2D
@onready var vieVerte = $Transition/PlayerHB/HBvide/HB
@onready var vieBleu = $Transition/PlayerHB/HBvide/HB2
var posX = 0 
var posY = 0
var cooldownAttack = false
func _ready():
	screen_size = get_viewport_rect().size
	screen_size_change = screen_size
	CollisionSlash.disabled = true
	calculClamp()
	RayDark.enabled = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	posY = moi.position.y
	posX = moi.position.x
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
					deplaTP(-85,"y")
				"down":
					deplaTP(85,"y")
				"right":
					deplaTP(85,"x")
				"left":
					deplaTP(-85,"x")
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
				
				
			"down":
				$PlayerSprite.animation = "idle_down"
			"right":
				$PlayerSprite.animation = "idle_right"
				
			"left":
				$PlayerSprite.animation = "idle_left"
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$PlayerSprite.play()
	
	else:
		$PlayerSprite.stop()
	taperEnCourant()
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		#print("I collided with ", collision.get_collider().name)

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
		await get_tree().create_timer(1).timeout
		$PlayerSprite/hitSprite.visible = false
		invincible = false
		var affichageDegats = degatsRecus*7800/100
		vieVerte.size.x = vieVerte.size.x- affichageDegats
		print(vieVerte.size.x)
		
func calculClamp():
	limit = Vector2(screen_size[0]*(int(cam.position.x/600)),screen_size[1]*(int(cam.position.y)/900)) 
	screen_size_change[0] = screen_size[0] + screen_size[0]*(int(cam.position.x)/600)
	screen_size_change[1] = screen_size[1] + screen_size[1]*(int(cam.position.y)/900)
func setup(posAsX, posAsY, rotAs, posAs2X, posAs2Y, rotAs2, posCoX, posCoY, rotCo ) :
	
	AreaSlash.rotation_degrees = rotCo
	AreaSlash.position.x = posX + posCoX 
	AreaSlash.position.y = posY + posCoY
	$PlayerSprite/AttackSprite.rotation_degrees = rotAs
	$PlayerSprite/AttackSprite.position.y = posY + posAsY
	$PlayerSprite/AttackSprite.position.x = posX + posAsX
	$PlayerSprite/AttackSprite2.rotation_degrees =rotAs2
	$PlayerSprite/AttackSprite2.position.x = posX+posAs2X
	$PlayerSprite/AttackSprite2.position.y = posY +posAs2Y
	
func taperEnCourant():
	if velocity.x > 0:
		if velocity.y < 0 :
			print("diag_haut_droit")
			setup(-5,-25,-10,-5,-30,-160,-20,0,-45)
		elif velocity.y > 0 :
			print("diag_bas_droit")
			setup(0,-20,107,0,-20,295,60,-40,70)
		else:
			print("droite")
			setup(-10,-20,50,0,-20,-126,-10,-30,0)
	elif velocity.x <0 :
		if velocity.y > 0 :
			print("diag_bas_gauche") 
			setup(-30,-10,160,-30,-10,17,40,40,142) 
		elif velocity.y < 0 :
			print("diag_haut_gauche")
			setup(-40,-30,-40,-35,-40,109,-60,30,-100)
		else:
			print("gauche")
			setup(-35,-5,250,-40,-11,62,0,70,199)
	else:
		if velocity.y < 0 :
			print("haut")
			setup(-20,-40,-32,-20,-45,165,-40,0,-77)
		elif velocity.y > 0 :
			print("bas")
			setup(-20,-5,141,-15,0,351,60,20,120)
func deplaTP(valeur, axe):
	if axe == "y":
		position.y+=valeur
	elif axe == "x": 
		position.x+= valeur  
