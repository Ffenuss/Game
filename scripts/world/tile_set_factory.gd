extends RefCounted
class_name TileSetFactory

const TILE_SIZE := Vector2i(16, 16)

const TILE_COORDS := {
	"tile.ground.dark_soil": Vector2i(0, 0),
	"tile.ground.cracked_soil": Vector2i(1, 0),
	"tile.ground.stone_ground": Vector2i(2, 0),
	"tile.ground.gravel": Vector2i(3, 0),
	"tile.road.path": Vector2i(0, 1),
	"tile.ground.grass_edge": Vector2i(1, 1),
	"tile.wall.cliff": Vector2i(2, 1),
	"tile.wall.mine": Vector2i(3, 1),
	"tile.floor.mine": Vector2i(0, 2),
	"tile.floor.wood": Vector2i(1, 2),
	"tile.bridge.wood": Vector2i(2, 2),
	"tile.water.shallow": Vector2i(3, 2),
	"tile.ground.rubble": Vector2i(0, 3),
	"tile.ground.glowing_mineral": Vector2i(1, 3),
	"tile.wall.furnace_metal": Vector2i(2, 3),
	"tile.transparent": Vector2i(3, 3),
}

const SOLID_TILE_IDS := {
	"tile.wall.cliff": true,
	"tile.wall.mine": true,
	"tile.wall.furnace_metal": true,
}


static func build_tileset() -> TileSet:
	var atlas_path := AssetCatalog.resolve_path("tile.ground.dark_soil")
	var atlas_texture := load(atlas_path) as Texture2D
	var tile_set := TileSet.new()
	tile_set.tile_size = TILE_SIZE
	var atlas_source := TileSetAtlasSource.new()
	atlas_source.texture = atlas_texture
	atlas_source.texture_region_size = TILE_SIZE
	for tile_id in TILE_COORDS.keys():
		atlas_source.create_tile(TILE_COORDS[tile_id])
	tile_set.add_source(atlas_source)
	return tile_set


static func get_tile_coords(tile_id: String) -> Vector2i:
	return TILE_COORDS.get(tile_id, TILE_COORDS["tile.transparent"])


static func is_solid_tile(tile_id: String) -> bool:
	return SOLID_TILE_IDS.get(tile_id, false)


