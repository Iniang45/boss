extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.modulate.a = 0.0


func lancer_flash(duree: float = 0.3, opacite_max: float = 0.8, couleur: Color = Color.WHITE) -> void:
	visible = true 
	color_rect.color = couleur
	color_rect.modulate.a = opacite_max
	
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(color_rect, "modulate:a", 0.0, duree)
