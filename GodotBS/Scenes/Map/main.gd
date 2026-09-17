extends Node2D
# Called when the node enters the scene tree for the first time.
#Chargement des noeuds pour plus de clarté 
@onready var moi = $Player
@onready var camera = $Player/Node/Camera2D
@onready var moiSprite = $Player/PlayerSprite
@onready var moiCollision = $Player/PlayerCollision
@onready var moiCollisionSlash = $Player/Slash/CollisionSlash
@onready var bossMorts = 0 
@onready var cam = $Player/Node/Camera2D
signal boss1Win
var boss1 = preload("res://Scenes/Boss/main_boss_1.tscn")
var caca = 0
var cinelance = false
func _ready():
	moi.calculClamp(cam)
	#CharacterBody2D#34779169954
func _process(delta):
	pass

func _on_debut_il_sort_debut():
#Fonction permettant de lancer le premier bossfight
	#print("kkk")
	if $debut.peutsortir:
		$Player.stopWaitAMinute = true 
		$Player.position = $MarkerDebut.position 
		lancementBoss1()
		$debut.peutsortir = false	

func _on_debut_ramasse():
	caca+=1
	print(caca)

func caseDepart():
	$Player.stopWaitAMinute = false
	cam.make_current()
	boss1Win.emit()
	

func lancementBoss1():
	var new_boss1 = boss1.instantiate()
	new_boss1.position = Vector2(0,0)
	add_child(new_boss1)
	new_boss1.changeCam()
	new_boss1.victoire.connect(caseDepart)





