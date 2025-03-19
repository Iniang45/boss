extends TileMap
@onready var france  = $Grosluffy/Corps
var breath = false
@onready var HB = $BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBar
@onready var HBTexte = $BossHealthBar/Label
@onready var HBB = $BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBarBlessure
@onready var GrosGros = $GrosGrosluffy
var attaqueBase = 10
signal toucheBoss
# Called when the node enters the scene tree for the first time.
func _ready():
	france.play("luffy")
	HB.size.x = 24000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (france.animation != "boroBreath") and (france.animation != "grosluffy") :
		france.play("luffy")
	if (france.animation == "boroBreath"):
		var frame = france.get_frame()
		if (frame == 6):
			$Grosluffy/Corps/Feu.play("Souffle")
	match france.animation : 
		"boroBreath" :
			if france.get_frame() > 7 :   
				$Grosluffy/CollisionFeu.disabled = false 
		"idle" : 
			$Grosluffy/CollisionFeu.visible = false

	


func _on_soisfranc_animation_finished():
	if (france.animation == "boroBreath"):
		france.play("luffy")
		$Grosluffy/CollisionFeu.disabled = true


	


func _on_gros_grosluffy_body_entered(body):
	if body.name != "TileMap":
		print("ca vous dirait un duel, attention c'est contre moi")
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
	var randanim = randi_range(1,4)
	match randanim : 
		1: $GrosGrosluffy/AnimatedSprite2D.flip_h = true
		3: $GrosGrosluffy/AnimatedSprite2D.flip_h = false
		4: $GrosGrosluffy/AnimatedSprite2D.flip_v = false
		2: $GrosGrosluffy/AnimatedSprite2D.animation = "flipv"
