extends Node2D
class_name LocationScene

@export var location_id: String = "collapsed_bridge"
@export var auto_spawn_player: bool = true

const DEFAULT_LEGEND := {
	".": "tile.ground.dark_soil",
	",": "tile.ground.cracked_soil",
	":": "tile.ground.gravel",
	"=": "tile.road.path",
	"~": "tile.water.shallow",
	"#": "tile.wall.cliff",
	"+": "tile.wall.mine",
	"b": "tile.bridge.wood",
	"g": "tile.ground.grass_edge",
	"r": "tile.ground.rubble",
	"m": "tile.ground.glowing_mineral",
	"w": "tile.floor.wood",
	"f": "tile.wall.furnace_metal",
	"x": "tile.transparent",
	" ": "tile.transparent",
}

const ENTITY_SCENES := {
	"player": "res://scenes/player/player.tscn",
	"ash_mite": "res://scenes/enemies/ash_mite.tscn",
	"petrified_wolf": "res://scenes/enemies/petrified_wolf.tscn",
	"hollow_miner": "res://scenes/enemies/hollow_miner.tscn",
	"training_dummy": "res://scenes/enemies/training_dummy.tscn",
	"tessa": "res://scenes/npc/tesa.tscn",
}

const FX_REGIONS := {
	"ash_particle": Rect2i(0, 0, 32, 32),
	"spark_particle": Rect2i(1, 0, 32, 32),
	"dust_particle": Rect2i(2, 0, 32, 32),
	"hit_flash": Rect2i(0, 1, 32, 32),
	"checkpoint_glow": Rect2i(1, 1, 32, 32),
	"mineral_glow": Rect2i(2, 1, 32, 32),
}

@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var ground_detail_layer: TileMapLayer = $GroundDetailLayer
@onready var road_layer: TileMapLayer = $RoadLayer
@onready var water_layer: TileMapLayer = $WaterLayer
@onready var wall_layer: TileMapLayer = $WallLayer
@onready var back_decoration_layer: TileMapLayer = $BackDecorationLayer
@onready var characters_layer: Node2D = $CharactersLayer
@onready var front_decoration_layer: TileMapLayer = $FrontDecorationLayer
@onready var effects_layer: Node2D = $EffectsLayer
@onready var fog_layer: Node2D = $FogLayer
@onready var spawn_points: Node2D = $SpawnPoints
@onready var interactables: Node2D = $Interactables
@onready var ui_layer: CanvasLayer = $UILayer

var _layout: Dictionary = {}
var _legend: Dictionary = DEFAULT_LEGEND.duplicate(true)
var _tile_set: TileSet = null
var _player_node: PlayerCharacter = null


func _ready() -> void:
	modulate = Color(0.84, 0.88, 0.93, 1.0)
	characters_layer.y_sort_enabled = true
	front_decoration_layer.y_sort_enabled = true
	back_decoration_layer.y_sort_enabled = true
	_load_layout()
	_apply_scene_metadata()
	_build_tileset()
	_populate_tile_layers()
	_spawn_static_collisions()
	_spawn_entities()
	_spawn_spatial_effects()
	_spawn_player_if_needed()


func _apply_scene_metadata() -> void:
	var display_name := String(_layout.get("display_name", location_id))
	GameState.set_location(location_id, display_name, get_scene_file_path())


func _load_layout() -> void:
	var path := "res://data/locations/%s.json" % location_id
	if not FileAccess.file_exists(path):
		push_warning("LocationScene: missing layout data %s" % path)
		_layout = {}
		return
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("LocationScene: unable to open layout data %s" % path)
		_layout = {}
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		_layout = parsed as Dictionary
		_legend = DEFAULT_LEGEND.duplicate(true)
		var custom_legend: Dictionary = _layout.get("legend", {})
		for key in custom_legend.keys():
			_legend[String(key)] = String(custom_legend[key])
	else:
		push_warning("LocationScene: invalid JSON in %s" % path)
		_layout = {}


func _build_tileset() -> void:
	_tile_set = TileSetFactory.build_tileset()
	_assign_tileset(ground_layer)
	_assign_tileset(ground_detail_layer)
	_assign_tileset(road_layer)
	_assign_tileset(water_layer)
	_assign_tileset(wall_layer)
	_assign_tileset(back_decoration_layer)
	_assign_tileset(front_decoration_layer)


func _assign_tileset(layer: TileMapLayer) -> void:
	if layer != null:
		layer.tile_set = _tile_set


func _populate_tile_layers() -> void:
	var layers: Dictionary = _layout.get("layers", {})
	for layer_name in layers.keys():
		var layer := _get_tile_layer(String(layer_name))
		if layer == null:
			continue
		_fill_layer(layer, layers[layer_name])


func _fill_layer(layer: TileMapLayer, rows_variant: Variant) -> void:
	if not (rows_variant is Array):
		return
	var rows: Array = rows_variant
	for y in rows.size():
		var row_text := String(rows[y])
		for x in row_text.length():
			var char := row_text.substr(x, 1)
			var tile_id := String(_legend.get(char, "tile.transparent"))
			if tile_id == "tile.transparent":
				continue
			var coords: Vector2i = TileSetFactory.get_tile_coords(tile_id)
			layer.set_cell(Vector2i(x, y), 0, coords, 0)


func _get_tile_layer(layer_name: String) -> TileMapLayer:
	match layer_name:
		"ground":
			return ground_layer
		"detail":
			return ground_detail_layer
		"road":
			return road_layer
		"water":
			return water_layer
		"wall":
			return wall_layer
		"back":
			return back_decoration_layer
		"front":
			return front_decoration_layer
		_:
			return null


func _spawn_static_collisions() -> void:
	var rows_variant: Variant = _layout.get("collision", [])
	if not (rows_variant is Array):
		return
	var rows: Array = rows_variant
	for y in rows.size():
		var row_text := String(rows[y])
		for x in row_text.length():
			var char := row_text.substr(x, 1)
			if char == "." or char == " ":
				continue
			var tile_id := String(_legend.get(char, "tile.transparent"))
			if tile_id == "tile.transparent":
				continue
			if not TileSetFactory.is_solid_tile(tile_id):
				continue
			var body := StaticBody2D.new()
			body.position = Vector2((x * 16) + 8, (y * 16) + 8)
			var collision := CollisionShape2D.new()
			var shape := RectangleShape2D.new()
			shape.size = Vector2(16, 16)
			collision.shape = shape
			body.add_child(collision)
			add_child(body)


func _spawn_entities() -> void:
	var entities: Array = _layout.get("entities", [])
	for entity_variant in entities:
		if not (entity_variant is Dictionary):
			continue
		var entity: Dictionary = entity_variant
		var kind := String(entity.get("kind", ""))
		var position_data: Array = entity.get("position", [0, 0])
		match kind:
			"checkpoint":
				_spawn_checkpoint(entity, position_data)
			"transition":
				_spawn_transition(entity, position_data)
			"dialogue":
				_spawn_dialogue_trigger(entity, position_data)
			"prop":
				_spawn_environment_prop(entity, position_data)
			"player":
				continue
			_:
				_spawn_scene_entity(entity, kind, position_data)


func _spawn_scene_entity(entity: Dictionary, kind: String, position_data: Array) -> void:
	var scene_key := String(entity.get("scene", ""))
	if scene_key == "":
		scene_key = String(entity.get("enemy_id", kind))
	var scene_path := String(ENTITY_SCENES.get(scene_key, ""))
	if scene_path == "":
		return
	if not ResourceLoader.exists(scene_path):
		push_warning("LocationScene: entity scene missing %s" % scene_path)
		return
	var packed := load(scene_path) as PackedScene
	if packed == null:
		return
	var node: Node = packed.instantiate()
	if position_data.size() >= 2:
		node.position = Vector2(float(position_data[0]), float(position_data[1]))
	if entity.has("checkpoint_id") and node.has_method("set"):
		node.set("checkpoint_id", String(entity["checkpoint_id"]))
	if entity.has("dialogue_id") and node.has_method("set"):
		node.set("dialogue_id", String(entity["dialogue_id"]))
	if entity.has("speaker_name") and node.has_method("set"):
		node.set("speaker_name", String(entity["speaker_name"]))
	if entity.has("target_location_id") and node.has_method("set"):
		node.set("target_location_id", String(entity["target_location_id"]))
	if entity.has("enemy_id") and node.has_method("set"):
		node.set("enemy_id", String(entity["enemy_id"]))
	if kind == "enemy":
		node.set("enemy_id", String(entity.get("enemy_id", kind)))
	characters_layer.add_child(node)


func _spawn_checkpoint(entity: Dictionary, position_data: Array) -> void:
	var checkpoint: CheckpointComponent = CheckpointComponent.new()
	checkpoint.checkpoint_id = String(entity.get("checkpoint_id", "checkpoint_%s" % location_id))
	checkpoint.prompt_text = String(entity.get("prompt_text", "Камень Тепла"))
	if position_data.size() >= 2:
		checkpoint.position = Vector2(float(position_data[0]), float(position_data[1]))
	var size_data: Array = entity.get("size", [20, 20])
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(float(size_data[0]), float(size_data[1]))
	collision.shape = shape
	checkpoint.add_child(collision)
	var glow := Sprite2D.new()
	glow.texture = _resolve_fx_texture("checkpoint_glow")
	glow.modulate = Color(1.0, 0.58, 0.18, 0.85)
	checkpoint.add_child(glow)
	interactables.add_child(checkpoint)


func _spawn_transition(entity: Dictionary, position_data: Array) -> void:
	var transition: LocationTransition = LocationTransition.new()
	transition.target_location_id = String(entity.get("target_location_id", ""))
	transition.prompt_text = String(entity.get("prompt_text", "Перейти дальше"))
	if position_data.size() >= 2:
		transition.position = Vector2(float(position_data[0]), float(position_data[1]))
	var size_data: Array = entity.get("size", [20, 20])
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(float(size_data[0]), float(size_data[1]))
	collision.shape = shape
	transition.add_child(collision)
	var marker := Sprite2D.new()
	marker.texture = AssetCatalog.texture("ui.save_icon")
	marker.modulate = Color(0.75, 0.85, 1.0, 0.8)
	transition.add_child(marker)
	interactables.add_child(transition)


func _spawn_dialogue_trigger(entity: Dictionary, position_data: Array) -> void:
	var trigger: DialogueTriggerComponent = DialogueTriggerComponent.new()
	trigger.dialogue_id = String(entity.get("dialogue_id", ""))
	trigger.speaker_name = String(entity.get("speaker_name", ""))
	trigger.prompt_text = String(entity.get("prompt_text", "Поговорить"))
	if position_data.size() >= 2:
		trigger.position = Vector2(float(position_data[0]), float(position_data[1]))
	var size_data: Array = entity.get("size", [20, 20])
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(float(size_data[0]), float(size_data[1]))
	collision.shape = shape
	trigger.add_child(collision)
	var icon := Sprite2D.new()
	icon.texture = AssetCatalog.texture("ui.button.interact")
	icon.modulate = Color(0.8, 0.95, 1.0, 0.75)
	trigger.add_child(icon)
	interactables.add_child(trigger)


func _spawn_environment_prop(entity: Dictionary, position_data: Array) -> void:
	var prop_id := String(entity.get("prop_id", ""))
	if prop_id == "":
		return
	var node: Node2D = Node2D.new()
	if position_data.size() >= 2:
		node.position = Vector2(float(position_data[0]), float(position_data[1]))
	var sprite := Sprite2D.new()
	sprite.texture = AssetCatalog.texture("environment.%s" % prop_id)
	sprite.centered = true
	node.add_child(sprite)
	if entity.get("light", false):
		var light := PointLight2D.new()
		light.texture = _resolve_fx_texture("checkpoint_glow")
		light.energy = 0.7
		light.color = Color(1.0, 0.72, 0.42, 1.0)
		node.add_child(light)
	back_decoration_layer.add_child(node)


func _spawn_player_if_needed() -> void:
	if not auto_spawn_player:
		return
	var spawn_position := _get_player_spawn_position()
	var player_scene_path := String(ENTITY_SCENES.get("player", ""))
	if player_scene_path == "" or not ResourceLoader.exists(player_scene_path):
		push_error("LocationScene: player scene missing")
		return
	var packed := load(player_scene_path) as PackedScene
	if packed == null:
		return
		var node: PlayerCharacter = packed.instantiate() as PlayerCharacter
	if node == null:
		return
	node.initialize(spawn_position, GameState.player_snapshot)
	characters_layer.add_child(node)
	_player_node = node
	if GameState.current_checkpoint_id == "":
		GameState.set_checkpoint("start_%s" % location_id, spawn_position, location_id)


func _get_player_spawn_position() -> Vector2:
	if GameState.current_checkpoint_id != "" and GameState.respawn_location_id == location_id:
		return GameState.respawn_position
	var spawn_data: Array = _layout.get("player_spawn", [64, 64])
	if spawn_data.size() >= 2:
		return Vector2(float(spawn_data[0]), float(spawn_data[1]))
	return Vector2(64, 64)


func _spawn_spatial_effects() -> void:
	var ash_sources: Array = _layout.get("ash_particles", [])
	for effect_variant in ash_sources:
		if not (effect_variant is Dictionary):
			continue
		var effect: Dictionary = effect_variant
		var effect_id := String(effect.get("effect_id", "ash_particle"))
		var position_data: Array = effect.get("position", [0, 0])
		if position_data.size() < 2:
			continue
		var particle: DriftingParticle = DriftingParticle.new()
		particle.texture = _resolve_fx_texture(effect_id)
		particle.position = Vector2(float(position_data[0]), float(position_data[1]))
		particle.drift_velocity = Vector2(float(effect.get("velocity_x", -8.0)), float(effect.get("velocity_y", -1.0)))
		particle.drift_amplitude = float(effect.get("amplitude", 3.0))
		particle.drift_frequency = float(effect.get("frequency", 1.0))
		particle.wrap_size = Vector2(float(effect.get("wrap_width", 512.0)), float(effect.get("wrap_height", 288.0)))
		effects_layer.add_child(particle)


func _resolve_fx_texture(effect_id: String) -> Texture2D:
	var texture_path := AssetCatalog.resolve_path("fx.%s" % effect_id)
	if texture_path == "":
		return null
	var texture := load(texture_path) as Texture2D
	if texture == null:
		return null
	var region: Rect2i = FX_REGIONS.get(effect_id, Rect2i())
	if region.size == Vector2i.ZERO:
		return texture
	var atlas_texture := AtlasTexture.new()
	atlas_texture.atlas = texture
	atlas_texture.region = Rect2(float(region.position.x), float(region.position.y), float(region.size.x), float(region.size.y))
	return atlas_texture
