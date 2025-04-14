extends Node2D
# Called when the node enters the scene tree for the first time.
#Chargement des noeuds pour plus de clarté 
@onready var moi = $Player
@onready var camera = $Player/Node/Camera2D
@onready var moiSprite = $Player/PlayerSprite
@onready var moiCollision = $Player/PlayerCollision
@onready var moiCollisionSlash = $Player/Slash/CollisionSlash
@onready var HB = $TileMap/BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBar
@onready var HBTexte = $TileMap/BossHealthBar/Label
@onready var HBB = $TileMap/BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBarBlessure
@onready var grosLuffy = $TileMap/Grosluffy
@onready var ylhan = $Boss2/Ylhan
var caca = 0
var cinelance = false
func _ready():
	
	grosLuffy.visible = false
	#CharacterBody2D#34779169954

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(str(moi.health)+"  "+str($TileMap/Soisfranc.VieBoss))
	if $Player/Transition/PlayerHB/HBvide/HB.size.x == 392:
		mort()
	#Triche permettant de tuer le boss ou de me tuer pour le debuggage
	if Input.is_action_just_pressed("InstaKill"):
		if $TileMap.mort==false:
			$TileMap/GrosGrosluffy.hitMarker(600)
			perteVieBoss(50, $TileMap.phase)
	if Input.is_action_just_pressed("self_damage"):
		moi.hitMarker(50)
	#Calcul de l'angle entre le boss et le joueur pour certaines attaques 
	if grosLuffy != null:
		grosLuffy.angle = rad_to_deg(moi.position.angle_to(grosLuffy.position))
		calculateDirection(grosLuffy,0)
	ylhan.angle = rad_to_deg(moi.position.angle_to(ylhan.position+Vector2(1100,0)))
	calculateDirection(ylhan,moi.screen_size[0])
	if ylhan.position.y - moi.position.y > 0:
		ylhan.rotation_degrees = 180 
	else:
		ylhan .rotation_degrees = 0



#Fonction permettant de calculer dans quelle direction le boss doit t-il se déplacer pour aller vers le joeuur 
func calculateDirection(ennemi,valeur):
	
	var ecartX = ennemi.position.x+valeur - moi.position.x
	var ecartY = ennemi.position.y - moi.position.y
	#print(ecartX)
	#print(ecartY)
	match ecartX>0:
		false:
			match ecartY>0:
				false:
					ennemi.directionState = ennemi.direction.basD
				true:
					ennemi.directionState = ennemi.direction.hautD
			ennemi.flip = false
		true:
			match ecartY>0:
				false:
					ennemi.directionState = ennemi.direction.basG
				true:
					ennemi.directionState = ennemi.direction.hautG
			ennemi.flip = true
			
			

func _on_player_hit():
#Fonction s'activant lorsque le joueur touche le boss avec son attaque
	match $TileMap.phase : 
		2:
			if $TileMap/Grosluffy != null:
				$TileMap/Grosluffy.hitMarker(moi.attaqueBase/2)
				if not $TileMap.mort:
					perteVieBoss(moi.attaqueBase, $TileMap.phase)
		1:
			$TileMap/GrosGrosluffy.hitMarker(moi.attaqueBase)
			if not $TileMap.mort:
					perteVieBoss(moi.attaqueBase, $TileMap.phase)
	if $TileMap.mort:
		print("c'est le WEP")
		perteVieBoss(moi.attaqueBase,$Boss2.phase)
	

func _on_debut_il_sort_debut():
#Fonction permettant de lancer le premier bossfight
	#print("kkk")
	$TileMap/Sombrero.visible = false
	if $debut.peutsortir:
		$Player.position.y -= 200
		if not cinelance:
			lancementCinematique($cinematique1)
			
		#camera.position.x = 581
		#camera.position.y = 327
		#moi.calculClamp()


func _on_debut_ramasse():
	caca+=1
	print(caca)
func lancementCinematique(cinematique):
	camera.position.x = cinematique.camx 
	camera.position.y = cinematique.camy 
	cinematique.lancement()


func _on_cinematique_1_animfini():
		cinelance = true
		camera.position.x = 581
		camera.position.y = 327
		moi.calculClamp()
		$TileMap/MusicPhase1.play()


func _on_tile_map_touche_boss():
	moi.hitMarker($TileMap.attaqueBase)
	
func mort():
	if not $TileMap.mort:
		$TileMap/ImFinished.visible = true
	else:
		$Boss2/EcranMort.visible = true
func perteVieBoss(valeur, quellePhase):
	#Rétrecissement de la barre de vie 
	var affichageDegats = valeur*2400/100
	match quellePhase:
		1:
	
			HB.size.x = HB.size.x- affichageDegats
			if HB.size.x == 1200 : 
				HB.visible = false
		2: 
			HBB.size.x = HBB.size.x- affichageDegats
			if HBB.size.x == 1188 : 
				HBB.visible = false
				if not $TileMap.mort:
					$TileMap.mortBoss()
				else:
					$Boss2.mortBoss()

func _on_cinematique_1_2_animfini_2():
	camera.position.x = 581
	camera.position.y = 327
	$TileMap.pause = false
	$TileMap/MusicPhase1.stop()
	$TileMap/MusicPhase2.play()

func _on_tile_map_phase_2_debut():
	lancementCinematique($Cinematique_1_2)

func _on_tile_map_touche_boss_2():
	moi.hitMarker($TileMap.attaqueBase)
	$Player/Transition/PlayerHB.visible = false


func _on_tile_map_touche_mc():
	moi.hitMarker($TileMap.attaqueBase)


func _on_tile_map_boss_mort():
	#Regain des pv du joueur lors de la mort du boss 
	moi.health = 100
	$TileMap.mort = true
	$Player/Transition/PlayerHB/HBvide/HB.size.x = 7800


func _on_tile_map_sortie():
	HB =  $Boss2/BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBar
	HBB = $Boss2/BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBarBlessure
	HBTexte = $Boss2/BossHealthBar/Label
	
	lancementCinematique($Cinematique2)
func _on_boss_2_touche_mc():
	moi.hitMarker($Boss2.attaqueBase)


func _on_cinematique_2_fini(name):
	match name:
		"cinematique":
			ylhan.pause = false
			moi.position.x = 1400
			camera.position.x = 1726
			camera.position.y = 327
			moi.calculClamp()
			print(moi.position)
			print(moi.limit)
			print(moi.screen_size[0])
			$Player/Transition/PlayerHB.position.x += moi.screen_size[0]
			$Boss2/MusicPhase1.play()
		"phase2":
			#$Boss2/MusicPhase2.play()
			$Boss2.phase1 = false
			$Boss2.phase = 2
			ylhan.scale = Vector2(3,3)
			ylhan.pause = false
			moi.position.x = 1400
			camera.position.x = 1726
			camera.position.y = 327
			moi.calculClamp()

func _on_boss_2_phase_2_debut():
	$Boss2/MusicPhase2.play()
	$Cinematique2.phase = 2
	lancementCinematique($Cinematique2)
