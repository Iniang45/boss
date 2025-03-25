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
		perteVieBoss(50)
	if Input.is_action_just_pressed("self_damage"):
		moi.hitMarker(50)
		
	
	







func _on_player_hit():
	#$TileMap/Grosluffy.hitMarker(moi.attaqueBase)
	$TileMap/GrosGrosluffy.hitMarker(moi.attaqueBase)
	perteVieBoss(moi.attaqueBase)
	


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


func _on_tile_map_touche_boss():
	print("main marche")
	moi.hitMarker($TileMap.attaqueBase)
	
func mort():
	var ecran = get_viewport_rect().size / 2
	$ImFinished.position.x = ecran[0]
	$ImFinished.position.y = ecran[1]
	$ImFinished.visible = true
func perteVieBoss(valeur):
	var affichageDegats = valeur*2400/100
	HB.size.x = HB.size.x- affichageDegats
	if HB.size.x == 1200 : 
		HB.visible = false
