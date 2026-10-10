extends CharacterBody2D
#Script de la phase 2 du premier Boss 
#Définition des variables et signaux
var pause = false
var invincible = false
var VieBoss = 100
signal bodyChange 
signal toucheBoss2
signal toucheDawg
var angle = 0
enum direction {hautG, basG, hautD, basD}
#Définition de la machine à états 
enum states {idle, pioche, grosluffy, arbre, pistobulle, deplacement}
var state : states = states.idle
var directionState : direction = direction.hautG
var flip = true
var piochePlayed = false
var nbanimfini = 0 
signal animfiniplease 
signal grosluffyAnim
var tween_hit : Tween 
@onready var souris = $Node/Souris
# Called when the node enters the scene tree for the first time.
func _ready():
	souris.size = Vector2(500,500)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	flipFunction(flip)
	
	move_and_slide()
	var limit = Vector2(80,90)
	var limitU  = Vector2(1075,575)
	position = position.clamp(limit,limitU)

func flipFunction(boolean):
	if boolean:
		$Corps.flip_h = true
	else:
		$Corps.flip_h = false
func phase2Behavior():
	#Fonctionnement de la machine à états
	match state:
		states.idle:
			velocity = Vector2.ZERO
		states.deplacement:
			# Mouvement physique appliqué uniquement pendant cet état
			deplacement()
		states.pioche:
			piocheAttaque()
	
func changer_etat(nouveau_state):
	state = nouveau_state
	nbanimfini = 0
	match state:
		states.idle:
			$Corps.play("luffy_idle")
			$Corps/Pioche/piocheCollision.disabled = true
			$Corps/Pioche/piocheCollisionReverse.disabled = true
			piochePlayed = false
			
			# Attend 2 secondes immobiles avant de se déplacer
			await get_tree().create_timer(0.3).timeout
			if state == states.idle:
				changer_etat(states.deplacement)

		states.deplacement:
			$AnimationPlayer2.play("walk") # Active enfin l'animation de marche !
			
			# Se déplace pendant 3 secondes puis lance une attaque aléatoire
			await get_tree().create_timer(1.5).timeout
			if state == states.deplacement and not pause:
				var rand_attack = randi_range(1, 4)
				match rand_attack:
					1: changer_etat(states.pistobulle)
					2: changer_etat(states.arbre)
					3: changer_etat(states.grosluffy)
					4: changer_etat(states.pioche)
		states.pioche:
			piocheAttaque()
		states.arbre:
			$AnimationPlayer2.play("arbre_souris")
		states.grosluffy:
			grosluffyAnima()
		states.pistobulle:
			$AnimationPlayer2.play("stickgun_souris")
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
func transformation():
	bodyChange.emit()
func deplacement():
	#Fonction permettant de gérer dans quelle direcion le boss doit se déplacer directionState est modifié dans une fonction de Main.gd
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
		$Corps.play("luffy")
	
	
func piocheAttaque():
	if nbanimfini==0:
		nbanimfini+=1
		$Corps.animation = "luffy_idle"
		
		piochePlayed = true 
		$AnimationPlayer2.play("pioche_souris")

func arbreAnimation():
	#l'arbre grandi 3 fois à intervalles de 0.5 secondes 
	$Corps.animation = "luffy_idle"
	$Arbremagique.rotation_degrees = angle + 90
	$Arbremagique.changementarbre(1)
	await get_tree().create_timer(0.5).timeout
	deplacement()
	$Arbremagique.changementarbre(2)
	await get_tree().create_timer(0.5).timeout
	$Arbremagique.changementarbre(3)
	await get_tree().create_timer(0.5).timeout
	$Arbremagique.changementarbre(4)
	changer_etat(states.idle)
	nbanimfini = 0
func grosluffyAnima():

	$AnimationPlayer2.play("gros_souris")
	nbanimfini =1	
func stickgun():
	#Fonctionne permettant de tirer des ventouse en appelant shoot du script de stickgun
	$Corps/Stickgun.visible = true 
	$Stickgun.shoot(position,angle,calculateVelocity())
	await get_tree().create_timer(1).timeout
	$Stickgun.shoot(position,angle,calculateVelocity())
	await get_tree().create_timer(1).timeout
	$Stickgun.arret()
	$Corps/Stickgun.visible = false
	changer_etat(states.idle)
	nbanimfini=0
func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"pioche":
			$Corps/Pioche/piocheCollision.disabled = true
			$Corps/Pioche.visible = false 
			state = states.idle
			piochePlayed = true
			nbanimfini=0 
			changer_etat(states.idle)
		"pioche_reverse":
			$Corps/Pioche/piocheCollision.disabled = true
			$Corps/Pioche.visible = false 
			state = states.idle
			piochePlayed = true 
			nbanimfini = 0
			changer_etat(states.idle)
			
func stopanim():
	animfiniplease.emit()

func _on_arealuffy_body_entered(body):
	#Fonction pour que le joueur prennent des dégats lorsqu'il entre en collsiison avec le boss
	print(body.name)
	if body.name == "Player":
		toucheDawg.emit()


func _on_pioche_body_entered(body):
	#Fonction pour que le joueur prennent des dégats lorsqu'il entre en collsiison avec la pioche
	if body.name == "Player":
		toucheDawg.emit()


func _on_animation_player_2_animation_finished(anim_name):
	#Les animations qui indiquent la prochaine attaque qui va arriver, l'attaque est lancée à la fin de ces animations
	match anim_name:
		"pioche_souris":
			$Corps/Pioche/piocheCollision.disabled = false
			velocity = Vector2.ZERO
			#print("kshotare")
			match $Corps.flip_h:
				false:
					
					$AnimationPlayer.play("pioche_reverse")
				true:
					$AnimationPlayer.play("pioche")	
			state = states.idle
			
		"arbre_souris":
			#print(nbanimfini)
			arbreAnimation()
		"gros_souris":
			grosluffyAnim.emit()
		"stickgun_souris":
			stickgun()

func _on_arbremagique_body_entered(body):
	#Fonction pour que le joueur prennent des dégats lorsqu'il entre en collsiison avec l'arbre magique
	toucheDawg.emit()
func calculateVelocity():
	#Fonctions permettant de diriger vers où la ventouse du stickgun va aller 
	var velociStickgun = Vector2.ZERO
	$Stickgun.rotation_degrees = angle + 180 
	match directionState:
		direction.hautG:
			velociStickgun.y -= 1
			velociStickgun.x -= 1
		direction.basG: 
			velociStickgun.y += 1
			velociStickgun.x -= 1
	
		direction.hautD :
			velociStickgun.x += 1
			velociStickgun.y -= 1
		direction.basD:
			velociStickgun.x += 1
			velociStickgun.y +=1
	#print(directionState)
	#print(angle)
	if velociStickgun.length() > 0:
		velociStickgun = velociStickgun.normalized() * 400
	return velociStickgun


func _on_stickgun_body_entered(body):
	toucheDawg.emit()

func restart():
	VieBoss = 100
	state = states.idle
	
func desactiver(booleen):
	if booleen:
		visible = false
		$Arealuffy/CollisionCorps.disabled = true
	else:
		visible = true
		$Arealuffy/CollisionCorps.disabled = false

