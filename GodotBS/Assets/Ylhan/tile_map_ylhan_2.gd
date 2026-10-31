extends TileMap

var tuiles_détruites : Dictionary = {}
const SOURCE_ID_VIDE : int = 1
const COORDS_VIDE_COLLISION : Vector2i = Vector2i(7, 9)
var position_origine : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	position_origine = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func secouer(duree : float = 0.2, intensite : float = 8.0) -> void:
	var tween = create_tween()
	for i in range(5):
		var offset = Vector2(
			randf_range(-intensite, intensite),
			randf_range(-intensite, intensite)
		)
		tween.tween_property(self, "position", position_origine + offset, duree / 5.0)
	tween.tween_property(self, "position", position_origine, 0.02)
func faire_flash(duree : float = 0.1) -> void:
	modulate = Color(3.5, 3.5, 3.5, 1.0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, duree)
func detruire_et_sauvegarder_tuile(tile_map, layer, coords) :
	var source_actuelle = tile_map.get_cell_source_id(layer, coords)
	var coords_actuelles = tile_map.get_cell_atlas_coords(layer, coords)
	if source_actuelle == -1 or (source_actuelle == SOURCE_ID_VIDE and coords_actuelles == COORDS_VIDE_COLLISION):
		return
	if not tuiles_détruites.has(coords):
		tuiles_détruites[coords] = {
			"source_id": source_actuelle,
			"atlas_coords": coords_actuelles,
			"alternative": tile_map.get_cell_alternative_tile(layer, coords)
		}
	tile_map.set_cell(layer, coords, SOURCE_ID_VIDE, COORDS_VIDE_COLLISION)

func restaurer_terrain(tile_map: TileMap, layer: int = 0) -> void:
	for coords in tuiles_détruites.keys():
		var info = tuiles_détruites[coords]
		tile_map.set_cell(
			layer, 
			coords, 
			info["source_id"], 
			info["atlas_coords"], 
			info["alternative"]
		)
	tuiles_détruites.clear()


func _on_slash_dimensionnel_animation_lancee():
	$Slash_dimensionnel/Node2D/Area2D/Collision.disabled = false
	secouer(0.25, 10.0)
	$Flash.lancer_flash(0.5, 1)


func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print(body)
	if body == self:
		var coords : Vector2i = get_coords_for_body_rid(body_rid)
		detruire_et_sauvegarder_tuile(self, 0, coords)


func _on_ylhan_phase_2_slash_dimensionnel():
	$Slash_dimensionnel.ActivateSlash(true)
