extends Node2D
# Called when the node enters the scene tree for the first time.
@onready var moi = $Player
@onready var camera = $Player/Node/Camera2D
@onready var moiSprite = $Player/PlayerSprite
@onready var moiCollision = $Player/PlayerCollision
@onready var moiCollisionSlash = $Player/Slash/CollisionSlash
@onready var HB = $TileMap/BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBar
@onready var HBTexte = $TileMap/BossHealthBar/Label
@onready var HBB = $TileMap/BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBarBlessure
@onready var grosLuffy = $TileMap/Grosluffy
var caca = 0
func _ready():
	
	pass
	#CharacterBody2D#34779169954

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(str(moi.health)+"  "+str($TileMap/Soisfranc.VieBoss))
	if $Player/Transition/PlayerHB/HBvide/HB.size.x == 392:
		mort()
	if Input.is_action_just_pressed("InstaKill"):
		$TileMap/GrosGrosluffy.hitMarker(50)
		perteVieBoss(50, $TileMap.phase)
	if Input.is_action_just_pressed("self_damage"):
		moi.hitMarker(50, $TileMap.phase)
		
	grosLuffy.angle = rad_to_deg(moi.position.angle_to(grosLuffy.position))
	calculateDirection(grosLuffy)
	





func calculateDirection(ennemi):
	var ecartX = ennemi.position.x - moi.position.x
	var ecartY = ennemi.position.y - moi.position.y
	match ecartX>0:
		true:
			match ecartY>0:
				true:
					ennemi.directionState = ennemi.direction.basD
				false:
					ennemi.directionState = ennemi.direction.hautD
			ennemi.flip = false
		false:
			match ecartY>0:
				true:
					ennemi.directionState = ennemi.direction.basG
				false:
					ennemi.directionState = ennemi.direction.hautG
			ennemi.flip = true
			
			

func _on_player_hit():
	match $TileMap.phase : 
		2:
			$TileMap/Grosluffy.hitMarker(moi.attaqueBase)
		1:
			$TileMap/GrosGrosluffy.hitMarker(moi.attaqueBase)
	perteVieBoss(moi.attaqueBase, $TileMap.phase)
	


func _on_debut_il_sort_debut():
	print("kkk")
	if $debut.peutsortir:
		$Player.position.y -= 200
		#lancementCinematique($cinematique1)
		camera.position.x = 581
		camera.position.y = 327
		moi.calculClamp()
	


func _on_debut_ramasse():
	caca+=1
	print(caca)
func lancementCinematique(cinematique):
	camera.position.x = cinematique.camx 
	camera.position.y = cinematique.camy 
	cinematique.lancement()


func _on_cinematique_1_animfini():
		camera.position.x = 581
		camera.position.y = 327
		moi.calculClamp()


func _on_tile_map_touche_boss():
	print("main marche")
	moi.hitMarker($TileMap.attaqueBase)
	
func mort():
	$TileMap/ImFinished.visible = true
func perteVieBoss(valeur, quellePhase):
	var affichageDegats = valeur*2400/100
	match quellePhase:
		1:
	
			HB.size.x = HB.size.x- affichageDegats
			if HB.size.x == 1200 : 
				HB.visible = false
		2: 
			HBB.size.x = HBB.size.x- affichageDegats
			if HBB.size.x == 1200 : 
				HBB.visible = false

func _on_cinematique_1_2_animfini_2():
	camera.position.x = 581
	camera.position.y = 327
	$TileMap.pause = false


func _on_tile_map_phase_2_debut():
	lancementCinematique($Cinematique_1_2)


func _on_tile_map_touche_boss_2():
	moi.hitMarker($TileMap.attaqueBase)
