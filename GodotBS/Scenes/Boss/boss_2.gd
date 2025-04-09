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
func changementPhase():
	pass
