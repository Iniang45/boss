extends TileMap
@onready var HB = $BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBar
@onready var HBTexte = $BossHealthBar/Label
var attaqueBase = 10
var phase2 = false
var pause = false
signal toucheBoss
signal toucheMC
signal bossMort
signal Sortie
signal phase2debut
var phase1 = true
var phase = 1
signal toucheBoss2
var mort = false
# Called when the node enters the scene tree for the first time.
func _ready():
	HBTexte.text = "Ylhan,UFC"
	HB.size.x = 24000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $BossHealthBar/HealthBarBG/HealthBarInterieur/HealthBar.size.x == 1200 and phase==1: 
		changementPhase()
	if $Ylhan/Slash2/CollisionSlash/RayCast2D.is_colliding() and $Ylhan/Slash2/CollisionSlash/RayCast2D.get_collider().name == "Player":
		print("ylahnnn")
		toucheMC.emit()
	if $Ylhan/Slash/CollisionSlash/RayCast2D.is_colliding()  and $Ylhan/Slash/CollisionSlash/RayCast2D.get_collider().name == "Player":
		toucheMC.emit()
func changementPhase():
	$MusicPhase1.stop()
	phase2debut.emit()
	pause = true
	phase = 2
	HBTexte.text = "Ylhan, La fin de la pause"
func mortBoss():
	if mort == false:
		$Ylhan.visible = false
		$Ylhan/Corps/CollisionShape2D.disabled = true
		pause = true
		$TextureRect.visible = true
		$MusicPhase2.stop()

func _on_ylhan_touche_dawg():
	toucheMC.emit()
