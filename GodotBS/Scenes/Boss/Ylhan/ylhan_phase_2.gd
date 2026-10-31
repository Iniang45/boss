extends CharacterBody2D

var invincible = false
var VieBoss = 100
var angle = 0

signal toucheDawg
const SPEED = 300.0
@export var projectile_scene: PackedScene
@onready var spawn_point: Node2D = $Pivot/Spawn
@onready var BossSprite = $Pivot/YlhanSprite
@onready var Slash = $Pivot/SuperSlash
@onready var IsGuarding = false 
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/playback")
signal slash_dimensionnel
var pause = true 
var tween_hit : Tween
var arbre_combos : Dictionary =  {
	"Idle": {
		"walk": 65,
		"multi_slash": 35
	},
	"walk": {
		"Slash_Moulinet": 100,
		"super_slash_R": 0,
		"super_slash_l": 0,
	},
	"super_slash_R": {
		"RESET": 50,
		"super_slash_l": 50
	},
	"super_slash_l": {
		"Slash_Moulinet": 100,
		"guard": 0,
		"super_slash_R": 0
	},
	"Slash_Moulinet": {
		"RESET": 0,
		"slash_dimensionnel" : 100
	},
	"guard": {
		"RESET": 100
	},
	"RESET": {
		"Idle": 100
	},
	"slash_dimensionnel" : {
		"RESET" : 100
	}
}
func _ready():
	anim_tree.active = true
	state_machine.start("Start")
	choisir_prochaine_etape("RESET")
	

func _physics_process(_delta):

	move_and_slide()

func lookAtPlayer(delta: float) -> Node2D:
	var joueur = get_tree().get_first_node_in_group("JoueurBoss2")
	if joueur == null:
		return null
		
	# Orientation du Pivot vers le joueur avec le décalage de -90°
	var angle_cible = global_position.angle_to_point(joueur.global_position)
	$Pivot.rotation = lerp_angle($Pivot.rotation, angle_cible + deg_to_rad(-90), 15 * delta)
	
	return joueur
func deplacement(delta: float) -> void:
	var joueur = lookAtPlayer(delta)
	if joueur == null:
		velocity = Vector2.ZERO
		return
	var direction = global_position.direction_to(joueur.global_position)
	velocity = direction * 150.0
	move_and_slide()

func activateGuard(boolean):
	IsGuarding = boolean
func attackLeft():
	Slash.flip_vertical(false)
	if  BossSprite.frame == 3:
		Slash.activerSlash(true)
func attackRight():
	Slash.flip_vertical(true)
	if  BossSprite.frame == 3:
		Slash.activerSlash(true)
	
func slashDimensionnel():
	slash_dimensionnel.emit()
func multiSlash():
	var proj = projectile_scene.instantiate()
	var dir_x : float = -1.0 if $Pivot.scale.x < 0 else 1.0
	var direction : Vector2 = Vector2(dir_x, 0)


	proj.global_position = spawn_point.global_position
	proj.direction = direction.rotated(deg_to_rad(90))
	proj.rotation = proj.direction.angle()

	get_parent().add_child(proj)
func tirer_au_sort_pondere(options: Dictionary) -> String:
	var poids_total : float = 0.0
	for poids in options.values():
		poids_total += poids

	var tirage : float = randf() * poids_total
	var cumul : float = 0.0

	for etat in options.keys():
		cumul += options[etat]
		if tirage <= cumul:
			return etat

	return options.keys()[0]
func choisir_prochaine_etape(etat_actuel: String) -> void:
	if arbre_combos.has(etat_actuel):
		var destination = tirer_au_sort_pondere(arbre_combos[etat_actuel])
		state_machine.travel(destination)
func _on_ylhan_sprite_frame_changed():
		match BossSprite.animation : 
			"attack_left": 
				attackLeft()
			"attack_right":
				attackRight()


func _on_animation_tree_animation_finished(anim_name):
	choisir_prochaine_etape(anim_name)
