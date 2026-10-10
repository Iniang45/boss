extends CharacterBody2D
#Cf soisfranc.gd
var invincible = false
var VieBoss = 100
signal bodyChange 
signal toucheBoss2
signal toucheDawg
var angle = 0
enum direction {hautG, basG, hautD, basD}
enum states {idle, attackLeft,attackRight, deplacement, moulinet}
var state : states = states.idle
var directionState : direction = direction.hautG
@onready var  slashcolli1 = $Pivot/Slash/CollisionSlash
@onready var slashcolli2 = $Pivot/Slash2/CollisionSlash
@onready var attaques = [$Pivot/Slash2, $Pivot/Slash, $Pivot/Slash_Moulinet]
var SPEED = 300.0
var nbanimfini = 0 
var animfiniL = false
var animfiniR = false
var flip = false
var pause = true 
var tween_hit : Tween 
func ready():
	pass

func _physics_process(delta):
	phase1(delta)
	#Permet au boss de ne pas toucher pendant les cinématiques
	if pause:
		velocity = Vector2.ZERO
	if state == states.moulinet and $Pivot/Slash_Moulinet.visible:
		$Pivot.rotation += 8 * delta
	move_and_slide()
	var limit = Vector2(40,30)
	var limitU  = Vector2(1155,624)
	#Permet au boss de pas sortir de la fenêtre
	position = position.clamp(limit,limitU)
func phase1(delta):
	#print($YlhanSprite.animation)
	#print(state)
	#$YlhanSprite.animation = "walk"
	#Définition de la machine à états de la même manière que dans le fichier soisfranc.gd
	match state:
		states.deplacement:
			deplacement(delta)

func changer_etat(nouveau_state):
	state = nouveau_state

	match state:
		states.idle:
			desacToutesCollisions()
			velocity = Vector2.ZERO
			$Pivot/YlhanSprite.play("idle")
			
			await get_tree().create_timer(0.5).timeout
			
			if state == states.idle:
				changer_etat(states.deplacement)

		states.deplacement:
			$Pivot/YlhanSprite.play("walk")
			
			await get_tree().create_timer(1.5).timeout
			print(pause, "hey hey hey")
			if state == states.deplacement and not pause:
				var rand_attack = randi_range(1,len(attaques))
				match rand_attack:
					1: changer_etat(states.attackRight)
					2: changer_etat(states.attackLeft)
					3: changer_etat(states.moulinet)

		states.attackLeft:
			attaqueLeft()

		states.attackRight:
			attaqueRight()
		states.moulinet:
			attaqueMoulinet()
func attaqueLeft() -> void:
	velocity = Vector2.ZERO
	$Pivot/YlhanSprite.play("attack_left")
	
	await gerer_collision_attaque(1, true)
	await $Pivot/YlhanSprite.animation_finished
	var rand_attack = randi_range(1,2)
	match rand_attack : 
		1: changer_etat(states.moulinet)
		2: changer_etat(states.idle)

func attaqueRight() -> void:
	velocity = Vector2.ZERO
	$Pivot/YlhanSprite.play("attack_right")
	
	await gerer_collision_attaque(0, true)
	await $Pivot/YlhanSprite.animation_finished
	var rand_attack = randi_range(1,2)
	match rand_attack : 
		1: changer_etat(states.moulinet)
		2: changer_etat(states.idle)
func attaqueMoulinet():
	desacToutesCollisions()
	velocity = Vector2.ZERO
	$Pivot/YlhanSprite.play("attack_double")
	await get_tree().create_timer(0.8).timeout
	$Pivot/Slash_Moulinet.visible = true 
	$Pivot/Slash_Moulinet/Moulinet1.play("moulinet")
	$Pivot/Slash_Moulinet/Moulinet2.play("moulinet")
	gerer_collision_attaque(2, true)
	await get_tree().create_timer(2.0).timeout
	gerer_collision_attaque(2,false)
	$Pivot/Slash_Moulinet.visible = false
	$Pivot/Slash_Moulinet/Moulinet1.stop()
	$Pivot/Slash_Moulinet/Moulinet2.stop()
	changer_etat(states.idle)
	
func gerer_collision_attaque(attaqueIndex, boolean):
	attaques[attaqueIndex].set_monitoring(boolean) 
	
func _on_ylhan_sprite_animation_finished():
	return 
	match $Pivot/YlhanSprite.animation : 
		"attack_left":
			gerer_collision_attaque(1,false)
			animfiniL = true
			#print("ca faire mal")
		"attack_right":
			gerer_collision_attaque(0,false)
			animfiniR = true 
func desacToutesCollisions():
	for i in range (len(attaques)):
		gerer_collision_attaque(i,false)
func deplacement(delta):
	#Fonction permettant au boss de se déplacer vers le joueur 
	lookAtPlayer(delta)
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
		velocity = velocity.normalized() * 150
		$Pivot/YlhanSprite.play("walk")
		#print(directionState)
	

func _on_corps_body_entered(body):
	#Signal émis lorsque le corps du boss touche le joueur 
	toucheDawg.emit()
func restart():
	state = states.idle
	SPEED = 300
	VieBoss = 100
func hitMarker(degatsRecus):
	#fonction permettant de gérer lorsque le boss reçoit des dégats,
	#print(invincible)
	VieBoss -= degatsRecus

	# Si le boss était déjà en train de flasher suite au coup précédent, on interrompt le flash
	if tween_hit and tween_hit.is_running():
		tween_hit.kill()

	# Flash rouge immédiat qui revient au blanc rapidement (0.15s)
	$Corps.modulate = Color(1, 0, 0)
	tween_hit = create_tween()
	tween_hit.tween_property($Corps, "modulate", Color.WHITE, 0.15)

func lookAtPlayer(delta):
	var joueur = get_tree().get_first_node_in_group("JoueurBoss2")
	print(joueur)
	if joueur == null:
		return
	var angle_cible = global_position.angle_to_point(joueur.global_position)
	$Pivot.rotation = lerp_angle($Pivot.rotation, angle_cible + deg_to_rad(-90), 15 * delta)
func _on_slash_body_entered(body):
	toucheDawg.emit()
	print("il est touche ")

	

func _on_slash_2_body_entered(body):
	toucheDawg.emit()
	print("il est touche ")


func _on_slash_moulinet_body_entered(body):
	toucheDawg.emit()
	print("moulinet l'a touché")
