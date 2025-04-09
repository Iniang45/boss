extends Area2D

@onready var listnoeuds = [$arbre1colli,$arbre2colli,$arbre3colli]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func changementarbre(arbre):
	
	
	match arbre:
		1:
			visible = true
			gestion($arbre1,true,$arbre1colli)
			gestion($arbre2,false,$arbre2colli)
			gestion($arbre3,false,$arbre3colli)
		2:
			visible = true
			gestion($arbre1,false,$arbre1colli)
			gestion($arbre2,true,$arbre2colli)
			gestion($arbre3,false,$arbre3colli)
		3:
			visible = true
			gestion($arbre1,false,$arbre1colli)
			gestion($arbre2,false,$arbre2colli)
			gestion($arbre3,true,$arbre3colli)
		4:
			visible = false
			gestion($arbre1,false,$arbre1colli)
			gestion($arbre2,false,$arbre2colli)
			gestion($arbre3,false,$arbre3colli)
func gestion(noeud,lebool,colli):
	
	noeud.visible = lebool
	if lebool:
		colli.disabled = false
	else:
		colli.disabled = true
