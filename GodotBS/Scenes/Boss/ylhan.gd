extends CharacterBody2D
var invincible = false
var VieBoss = 100
signal bodyChange 
signal toucheBoss2
signal toucheDawg
var angle = 0
enum direction {hautG, basG, hautD, basD}
enum states {idle, attackLeft,attackRight, deplacement}
var state : states = states.idle
var directionState : direction = direction.hautG
@onready var  slashcolli1 = $Slash/CollisionSlash
@onready var slashcolli2 = $Slash2/CollisionSlash
const SPEED = 300.0
var nbanimfini = 0 
var animfiniL = false
var animfiniR = false
func ready():
	slashcolli1.disabled = true
	slashcolli2.disabled = true 

func _physics_process(delta):
	phase1()
	#move_and_slide()
	
func phase1():
	#print($YlhanSprite.animation)
	#print(state)
	#$YlhanSprite.animation = "walk"
	
	match state:
		states.idle:
			$YlhanSprite.play("idle")
			await get_tree().create_timer(1).timeout
			var randattack = randi_range(1,2)
			match randattack:
				1:
					state = states.attackRight
				2:
					state = states.attackLeft
		states.attackLeft:
	
			slashcolli1.disabled = false
			if not animfiniL: 
				#print("statejj")
				$YlhanSprite.play("attack_left")
			if animfiniL :
				state = states.idle
				animfiniL = false
			
		states.attackRight:
			slashcolli2.disabled = false
			if not animfiniR: 
				#print("statejj")
				$YlhanSprite.play("attack_right")
			if animfiniR :
				state = states.idle
				animfiniR = false	


func _on_ylhan_sprite_animation_finished():
	match $YlhanSprite.animation : 
		"attack_left":
			animfiniL = true
			print("ca faire mal")
		"attack_right":
			animfiniR = true 
