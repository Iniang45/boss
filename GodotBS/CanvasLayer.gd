extends CanvasLayer
@onready var color_rect = $ColorRect
# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.color.a = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func fade(color,duration):
	visible = true 
	var tween = create_tween()
	tween.tween_property(color_rect,"color:a",color,duration)
	return tween 
func return_to_black():
	color_rect.color.a = 1
