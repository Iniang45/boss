extends Area2D
var invincible = false
var VieBoss = 100
signal bodyChange 
signal toucheBoss2
var angle = 0
enum direction {hautG, basG, hautD, basD}
enum states {idle, pioche, grosluffy, arbre, pistobulle, deplacement}
var velocity = Vector2.ZERO
var state : states = states.idle
var directionState : direction = direction.hautG
var flip = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flip:
		$Corps.flip_h = true
	else:
		$Corps.flip_h = false



func phase2Behavior():
	match state :
		states.idle:
			await get_tree().create_timer(0.3).timeout
			velocity=Vector2.ZERO
			state = states.deplacement
		states.deplacement:
			deplacement()
			await get_tree().create_timer(3).timeout
			state = states.pioche
		states.pioche : 
			piocheAttaque()
		
func hitMarker(degatsRecus):
	if not invincible :
		VieBoss-=degatsRecus
		invincible = true
		$hitSprite.visible = true 
		await get_tree().create_timer(0.3).timeout
		$hitSprite.visible = false
		invincible = false
func transformation():
	bodyChange.emit()
func deplacement():
	match direction:
		direction.hautG:
			velocity.y -= 1
			velocity.x -= 1
		direction.basG: 
			velocity.y += 1
			velocity.x -= 1
		direction.hautD :
			velocity.x += 1
			velocity.y -= 1
		direction.basD:
			velocity.x += 1
			velocity.y +=1
	if velocity.length() > 0:
		velocity = velocity.normalized() * 100
		$Corps.play("luffy")
	
	
func piocheAttaque():
	velocity = Vector2.ZERO
	$Corps.animation = "luffy_idle"
	$Pioche/piocheCollision.disabled = false
	$AnimationPlayer.play("pioche")
	



func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"pioche":
			$Pioche/piocheCollision.disabled = true
			state = states.idle

	
