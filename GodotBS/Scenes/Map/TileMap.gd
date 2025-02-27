extends TileMap
@onready var france  = $Grosluffy/Corps
var breath = false
@onready var HB = $BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBar
@onready var HBTexte = $BossHealthBar/Label
@onready var HBB = $BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBarBlessure
var attaqueBase = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	france.play("luffy")
	HB.size.x = 24000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_released("tp"):
		france.play("boroBreath")
	else:
		if (france.animation != "boroBreath") :
			france.play("luffy")
	if (france.animation == "boroBreath"):
		var frame = france.get_frame()
		if (frame == 6):
			$Soisfranc/Corps/Feu.play("Souffle")
	match france.animation : 
		"boroBreath" :
			if france.get_frame() > 7 :   
				$Soisfranc/CollisionFeu.disabled = false 
		"idle" : 
			$Soisfranc/CollisionFeu.visible = false

	


func _on_soisfranc_animation_finished():
	if (france.animation == "boroBreath"):
		france.play("luffy")
		$Soisfranc/CollisionFeu.disabled = true


	
