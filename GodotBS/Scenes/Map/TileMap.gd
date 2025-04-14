extends TileMap
#Définition de différents signaux et variables 
@onready var france  = $Grosluffy/Corps
var breath = false
@onready var HB = $BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBar
@onready var HBTexte = $BossHealthBar/Label
@onready var HBB = $BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBarBlessure
@onready var GrosGros = $GrosGrosluffy
signal phase2debut
var attaqueBase = 10
var phase2 = false
var pause = false
signal toucheBoss
signal toucheMC
signal bossMort
signal Sortie
var phase1 = true
var phase = 1
signal toucheBoss2
var mort = false
# Called when the node enters the scene tree for the first time.
func _ready():
	HBTexte.text = "GrosLuffy"
	france.play("luffy")
	HB.size.x = 24000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBar.size.x == 1200 and phase==1: 
		changementPhase()
	if pause and mort == false :
		$GrosGrosluffy.velocity = Vector2.ZERO 
	if phase == 2 and mort== false:
		#print("il sont là, les quenouilles")
		$Grosluffy.phase2Behavior() 


	


func _on_gros_grosluffy_body_entered(body):
	#Fonction permettant de gérer les rebonds de GrosGrosLuffy si ce n'est pas un mur qui a pour nom "TileMap"
	#Alors c'est forcément le joueur donc on émet le signal qu'il s'est fait touché sinon il rebondit de manière semi-aléatoire
	#Il ne peux pas rebondir à gauche si il touche le mur de gauche par exemple
	if body.name != "TileMap":
		#print("ca vous dirait un duel, attention c'est contre moi")
		toucheBoss.emit()
	else:
		randomanim()
		if GrosGros.position.x > $Marker.position.x :
			GrosGros.vecteurX = randi_range(-200,0)
			#print("à gauche")
		else : 
			GrosGros.vecteurX = randi_range(0,200)
			#print("à droite")
		if GrosGros.position.y > $Marker.position.y : 
			GrosGros.vecteurY = randi_range(-150,0)
			#print("en haut")
		else:
			GrosGros.vecteurY = randi_range(0,150)
			#print("en bas")
			
func randomanim() : 
	#Fonction pour animer le boss
	var randanim = randi_range(1,4)
	match randanim : 
		1: $GrosGrosluffy/AnimatedSprite2D.flip_h = true
		3: $GrosGrosluffy/AnimatedSprite2D.flip_h = false
		4: $GrosGrosluffy/AnimatedSprite2D.flip_v = false
		2: $GrosGrosluffy/AnimatedSprite2D.animation = "flipv"
func changementPhase():
	#Fonction permettant de passer de la phase 1 à la phase 2 
	$Grosluffy.position = Vector2(300,300)

	phase2debut.emit()
	pause = true
	phase = 2
	HBTexte.text = "Narrateur et Luffy, la toon force"
	#$GrosGrosluffy.visible = false
	$GrosGrosluffy/CollisionShape2D.disabled = true
	$GrosGrosluffy.visible = false
	$Grosluffy.visible = true
	$Grosluffy/Arealuffy/CollisionCorps.disabled = false 

func mortBoss():
	#Fonction permettantg de gérer la mort du boss
	if mort == false:
		$GrosGrosluffy.queue_free()
		$Grosluffy.queue_free()
		$AnimationBoss1.play("mortGL")
		bossMort.emit()
		$MusicPhase2.stop()
		$BossHealthBar.visible = false
	
func _on_grosluffy_touche_dawg():
	toucheMC.emit()


func _on_grosluffy_grosluffy_anim():
	#Fonction permettant de gérer l'attaque Grosluffy de la phase 2, on réactive les collisions et on rend visible le ballon tout en rendant invisible luffy, puis on fait l'inverse au bout de 5 secondes
	pause = false
	$GrosGrosluffy.position = Vector2(500,500)
	$GrosGrosluffy.visible = true 
	$GrosGrosluffy/CollisionShape2D.disabled = false 
	$Grosluffy/Arealuffy/CollisionCorps.disabled = true 
	$Grosluffy.visible = false
	print($GrosGrosluffy.visible)
	print($GrosGrosluffy.position)
	await get_tree().create_timer(5).timeout
	$Grosluffy.position = $GrosGrosluffy.position
	$GrosGrosluffy.visible = false
	$GrosGrosluffy/CollisionShape2D.disabled = true 
	$Grosluffy.visible = true
	$Grosluffy/Arealuffy/CollisionCorps.disabled = false 
	$Grosluffy.state = $Grosluffy.states.idle
	pause = true


func _on_sortie_boss_body_entered(body):
	#Fonction pour émettre le signal qu'on passe au second boss
	if mort:
		Sortie.emit()
		
