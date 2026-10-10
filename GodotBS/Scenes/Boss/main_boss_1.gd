extends Node2D
@export var cam : Camera2D
@onready var camera = $Node/Camera2D
@export var fade : CanvasLayer
@export var moi : CharacterBody2D
@export var BossScene : TileMap
@onready var HB = BossScene.HB
@onready var HBTexte = BossScene.HBTexte
@onready var HBB = BossScene.HBB
@onready var Boss = BossScene.boss
@export var gameOver : TextureButton
@export var Cinematiques : Array[Control]
var cinelance = false
@export var lookAt : bool 
signal victoire 
# Called when the node enters the scene tree for the first time.
func _ready():
	moi.calculClamp(cam)
	BossScene.boss.visible = false
	changeCam()
	if len(Cinematiques) != 0:	
		lancementCinematique(Cinematiques[0],"RESET")
	connectSignals(BossScene)
	connectSignals(moi)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player/Transition/PlayerHB/HBvide/HB.size.x == 392:
		mort()
	#Triche permettant de tuer le boss ou de me tuer pour le debuggage
	if Input.is_action_just_pressed("InstaKill"):
		BossScene.boss.hitMarker(1200)
		perteVieBoss(100, BossScene.phase)
	if Input.is_action_just_pressed("self_damage"):
		moi.hitMarker(50)
	#Calcul de l'angle entre le boss et le joueur pour certaines attaques 
	if BossScene.boss != null:
		BossScene.boss.angle = rad_to_deg(moi.position.angle_to(BossScene.boss.position))
		calculateDirection(BossScene.boss,0)
		
		

func mort():
	moi.pause(true)
	BossScene.affichageGameOver()
	$Node/Camera2D/gameOver/gameOverPhrase.text = $TileMap.gameOverText
	$Node/Camera2D/gameOver/gameOverPerso.texture = load($TileMap.gameOverImage)
	gameOver.visible = true
	
func changeCam():
	cam.make_current()

func perteVieBoss(valeur, quellePhase):
	#Rétrecissement de la barre de vie 
	var affichageDegats = valeur*2400/100
	match quellePhase:
		1:
			HB.visible = true
			HB.size.x = HB.size.x- affichageDegats
			if HB.size.x == 1200 : 
				HB.visible = false
		2: 
			HBB.size.x = HBB.size.x- affichageDegats
			if HBB.size.x == 1188 : 
				HBB.visible = false
				$TileMap.mortBoss()


func calculateDirection(ennemi,valeur):
	if ennemi.get("direction") == null : 
		return
	
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
	print("omaera")
#Fonction s'activant lorsque le joueur touche le boss avec son attaque
	match BossScene.phase : 
		2:
			if BossScene.boss != null:
				BossScene.boss.hitMarker(moi.attaqueBase/2)
				if not BossScene.mort:
					perteVieBoss(moi.attaqueBase, BossScene.phase)
		1:
			print("zizicopter")
			BossScene.boss.hitMarker(moi.attaqueBase)
			if not BossScene.mort:
					perteVieBoss(moi.attaqueBase, BossScene.phase)

func _on_tile_map_touche_boss():
	moi.hitMarker(BossScene.attaqueBase, BossScene.boss.position)


func _on_tile_map_touche_mc():
	moi.hitMarker(BossScene.attaqueBase, BossScene.boss.position)
	
func _on_tile_map_touche_boss_2():
	moi.hitMarker(BossScene.attaqueBase, BossScene.boss.position)
	$Player/Transition/PlayerHB.visible = false	
func lancementCinematique(cinematique,cine):
	if cinematique != null:
		cam.position.x = cinematique.pos_camx
		cam.position.y = cinematique.pos_camy 
		print("getheeyyy", cam.position)
		await fade.fade(0.0,1.0).finished
		fade.return_to_black()
		fade.visible = false
		moi.invincible = true
		cinematique.lancement(cine)
	
func _on_tile_map_phase_2_debut():
	BossScene.pause = true 
	lancementCinematique(Cinematiques[1],"phase")

func _on_cinematique_1_animfini():
		cinematiqueIntroEnd()
		return
		cinelance = true
		camera.position.x = 581
		camera.position.y = 327
		moi.calculClamp(cam)
		moi.invincible = false
		moi.position = Vector2(550,580)
		$TileMap/MusicPhase1.play()
		$TileMap/GrosGrosluffy.position = Vector2(930,347)

func _on_cinematique_1_2_animfini_2():
	camera.position.x = 581
	camera.position.y = 327
	#print($TileMap.mort)
	moi.invincible = false
	$TileMap/Grosluffy.desactiver(false)
	$TileMap/MusicPhase1.stop()
	$TileMap/MusicPhase2.play()
	BossScene.boss.pause = false
	BossScene.boss.position = Vector2(937,305)


func _on_cinematique_1_2_animfini_mort():
	await fade.fade(0.0,1.0).finished
	fade.return_to_black()
	fade.visible = false
	moi.calculClamp(cam)
	moi.position = camera.position
	moi.invincible = false
	victoire.emit()
	queue_free()
func _on_game_over_pressed():
	$Node/Camera2D/gameOver.visible = false
	$Player/Transition/PlayerHB/HBvide/HB.size.x = 7800
	$Player.restart(camera.position.x,camera.position.y)
	$TileMap.restart()

func _on_tile_map_boss_mort():
	#Regain des pv du joueur lors de la mort du boss 
	moi.health = 100
	$TileMap.mort = true
	lancementCinematique(Cinematiques[1],"fin")
	$Player/Transition/PlayerHB/HBvide/HB.size.x = 7800



func cinematiqueIntroEnd():
	cinelance = true 
	cam.position.x = 581
	cam.position.y = 327
	moi.calculClamp(cam)
	moi.invincible = false
	moi.position = Vector2(550,580)
	BossScene.musique[0].play()
	BossScene.boss.position = Vector2(550,305)
	BossScene.boss.visible = true
	BossScene.pause = false 
	BossScene.boss.changer_etat(BossScene.boss.states.idle)
	
	
	
func _on_cinematique_2_fini(name):
		if name == "cinematique":
			cinematiqueIntroEnd()
func connectSignals(noeud):
	var signalList = noeud.get_signal_list()
	for sig in signalList:
		var signalName = sig["name"]
		var targetMethod = "_on_" + noeud.name + "_" + signalName.to_snake_case()
		if has_method(targetMethod):
			if not noeud.is_connected(signalName, Callable(self, targetMethod)):
				noeud.connect(signalName, Callable(self, targetMethod))
				print("Signal connecté avec succès : ", signalName, " -> ", targetMethod)
	


