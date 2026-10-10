extends Area2D

@export var degats := 15
var cibles_touchees := [] # Enregistre les ennemis déjà frappés par CE slash

func _on_area_entered(area: Area2D) -> void:
	# On vérifie si la cible a une fonction hitMarker ET n'a pas encore été touchée
	if area.has_method("hitMarker") and not area in cibles_touchees:
		cibles_touchees.append(area) # On la note comme touchée
		area.hitMarker(degats)
