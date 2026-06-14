extends SceneTree

const GENERATED_DIR := "res://assets/generated/placeholders"
const GENERATED_ENVIRONMENT_DIR := "res://assets/generated/placeholders/environment"
const RUNTIME_UI_DIR := "res://assets/runtime/ui"
const RUNTIME_ENVIRONMENT_DIR := "res://assets/runtime/environment"
const UI_ATLAS_SIZE := Vector2i(256, 256)
const BACKDROP_SIZE := Vector2i(640, 360)
const WORLD_BACKDROP_SIZE := Vector2i(640, 360)

const GRAPHITE_DARK := Color(0.05, 0.05, 0.06, 1.0)
const GRAPHITE := Color(0.10, 0.11, 0.13, 1.0)
const GRAPHITE_LIGHT := Color(0.18, 0.19, 0.22, 1.0)
const STONE := Color(0.32, 0.34, 0.38, 1.0)
const STONE_LIGHT := Color(0.55, 0.57, 0.60, 1.0)
const BLUEGRAY := Color(0.34, 0.43, 0.50, 1.0)
const BLUEGRAY_LIGHT := Color(0.62, 0.70, 0.76, 1.0)
const BROWN := Color(0.35, 0.26, 0.20, 1.0)
const BROWN_LIGHT := Color(0.55, 0.41, 0.29, 1.0)
const ASH := Color(0.82, 0.83, 0.82, 1.0)
const ASH_DARK := Color(0.54, 0.56, 0.55, 1.0)
const FURNACE := Color(0.83, 0.42, 0.14, 1.0)
const FURNACE_LIGHT := Color(0.95, 0.64, 0.29, 1.0)
const DAMAGE := Color(0.55, 0.17, 0.16, 1.0)
const DAMAGE_LIGHT := Color(0.81, 0.35, 0.30, 1.0)
const HEAL := Color(0.35, 0.61, 0.42, 1.0)
const HEAL_LIGHT := Color(0.53, 0.82, 0.61, 1.0)
const NIGHT := Color(0.04, 0.05, 0.07, 1.0)


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	_ensure_directories()
	_generate_ui_atlas()
	_generate_backdrop()
	_generate_world_backdrop()
	print("Placeholder generation completed.")
	quit(0)


func _ensure_directories() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(GENERATED_DIR))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(GENERATED_ENVIRONMENT_DIR))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(RUNTIME_UI_DIR))
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(RUNTIME_ENVIRONMENT_DIR))


func _generate_ui_atlas() -> void:
	var image := Image.create(UI_ATLAS_SIZE.x, UI_ATLAS_SIZE.y, false, Image.FORMAT_RGBA8)
	image.fill(GRAPHITE_DARK)
	for y in range(4):
		for x in range(4):
			_draw_ui_cell(image, Rect2i(x * 64, y * 64, 64, 64), x, y)
	_save_image(image, "%s/ui_placeholder_atlas.png" % GENERATED_DIR, "%s/ui_placeholder_atlas.png" % RUNTIME_UI_DIR)


func _generate_backdrop() -> void:
	var image := Image.create(BACKDROP_SIZE.x, BACKDROP_SIZE.y, false, Image.FORMAT_RGBA8)
	for y in range(BACKDROP_SIZE.y):
		for x in range(BACKDROP_SIZE.x):
			var uv := Vector2(float(x) / float(BACKDROP_SIZE.x - 1), float(y) / float(BACKDROP_SIZE.y - 1))
			var center := Vector2(0.52, 0.48)
			var dist := uv.distance_to(center)
			var edge: float = clamp((dist - 0.12) / 0.58, 0.0, 1.0)
			var warm: float = clamp(1.0 - abs(uv.x - 0.50) * 1.7 - abs(uv.y - 0.52) * 1.4, 0.0, 1.0)
			var color: Color = NIGHT.lerp(GRAPHITE, 0.45)
			color = color.lerp(Color(0.11, 0.12, 0.15, 1.0), warm * 0.42)
			color = color.lerp(Color(0.20, 0.12, 0.08, 1.0), warm * 0.12)
			color = color.lerp(NIGHT, edge * 0.92)
			color.a = 1.0
			image.set_pixel(x, y, color)
	_save_image(image, "%s/ui_background_vignette.png" % GENERATED_DIR, "%s/ui_background_vignette.png" % RUNTIME_UI_DIR)


func _generate_world_backdrop() -> void:
	var image := Image.create(WORLD_BACKDROP_SIZE.x, WORLD_BACKDROP_SIZE.y, false, Image.FORMAT_RGBA8)
	var rng := RandomNumberGenerator.new()
	rng.seed = 0xA5D0F0
	for y in range(WORLD_BACKDROP_SIZE.y):
		var v: float = float(y) / float(WORLD_BACKDROP_SIZE.y - 1)
		var sky_mix: float = clamp(1.0 - abs(v - 0.42) * 1.9, 0.0, 1.0)
		var base: Color = NIGHT.lerp(GRAPHITE_DARK, 0.24 + v * 0.42)
		for x in range(WORLD_BACKDROP_SIZE.x):
			var u: float = float(x) / float(WORLD_BACKDROP_SIZE.x - 1)
			var edge_mix: float = clamp(min(u, 1.0 - u) * 3.0, 0.0, 1.0)
			var glow: float = clamp(1.0 - Vector2(u - 0.53, v - 0.58).length() * 2.1, 0.0, 1.0)
			var fog_band: float = clamp(1.0 - abs(v - 0.55) * 4.0, 0.0, 1.0)
			var color: Color = base
			color = color.lerp(Color(0.07, 0.08, 0.10, 1.0), sky_mix * 0.34)
			color = color.lerp(Color(0.06, 0.07, 0.08, 1.0), edge_mix * 0.50)
			color = color.lerp(Color(0.20, 0.12, 0.08, 1.0), glow * 0.16)
			color = color.lerp(Color(0.12, 0.13, 0.16, 1.0), fog_band * 0.14)
			var grain: float = sin((x * 0.13) + (y * 0.17)) * 0.012 + cos((x * 0.07) - (y * 0.11)) * 0.008
			if grain >= 0.0:
				color = color.lightened(grain)
			else:
				color = color.darkened(-grain)
			image.set_pixel(x, y, color)

	# Add cliff silhouettes along the edges to reduce the empty gray feeling.
	for y in range(WORLD_BACKDROP_SIZE.y):
		var left_depth: int = int(44 + 18 * sin(float(y) * 0.06) + 10 * sin(float(y) * 0.19))
		var right_depth: int = int(54 + 18 * sin(float(y) * 0.08 + 1.3) + 12 * sin(float(y) * 0.16))
		var top_ridge: int = int(18 + 8 * sin(float(y) * 0.05 + 0.8))
		for x in range(left_depth):
			_plot(image, x, y, GRAPHITE_DARK.darkened(0.15))
		for x in range(WORLD_BACKDROP_SIZE.x - right_depth, WORLD_BACKDROP_SIZE.x):
			_plot(image, x, y, GRAPHITE_DARK.darkened(0.18))
		if y < top_ridge:
			for x in range(WORLD_BACKDROP_SIZE.x):
				if x % 18 < 13:
					_plot(image, x, y, GRAPHITE_DARK.darkened(0.12))

	# Add a lower broken ridge to frame the play space.
	for x in range(0, WORLD_BACKDROP_SIZE.x, 4):
		var ridge_height: int = int(12 + 6 * sin(float(x) * 0.035) + 4 * sin(float(x) * 0.09 + 0.8))
		for y in range(WORLD_BACKDROP_SIZE.y - ridge_height, WORLD_BACKDROP_SIZE.y):
			_plot(image, x, y, BROWN.darkened(0.55))
			_plot(image, x + 1, y, GRAPHITE_DARK)
			_plot(image, x + 2, y, GRAPHITE_DARK)
			_plot(image, x + 3, y, GRAPHITE_DARK.darkened(0.1))

	# Warm furnace hint to make the scene feel inhabited instead of neutral.
	for y in range(WORLD_BACKDROP_SIZE.y):
		for x in range(WORLD_BACKDROP_SIZE.x):
			var glow_center: Vector2 = Vector2(0.57, 0.64)
			var glow: float = clamp(1.0 - Vector2(float(x) / WORLD_BACKDROP_SIZE.x - glow_center.x, float(y) / WORLD_BACKDROP_SIZE.y - glow_center.y).length() * 2.3, 0.0, 1.0)
			if glow > 0.0:
				var current: Color = image.get_pixel(x, y)
				current = current.lerp(Color(0.42, 0.20, 0.10, 1.0), glow * 0.26)
				image.set_pixel(x, y, current)

	# Sparse ash specks.
	for i in range(240):
		var px: int = rng.randi_range(0, WORLD_BACKDROP_SIZE.x - 1)
		var py: int = rng.randi_range(0, WORLD_BACKDROP_SIZE.y - 1)
		var size: int = rng.randi_range(1, 2)
		var ash_color: Color = ASH_DARK if rng.randi_range(0, 1) == 0 else ASH
		for oy in range(size):
			for ox in range(size):
				_plot(image, px + ox, py + oy, ash_color)

	_save_image(
		image,
		"%s/world_backdrop_mist.png" % GENERATED_ENVIRONMENT_DIR,
		"%s/world_backdrop_mist.png" % RUNTIME_ENVIRONMENT_DIR
	)


func _draw_ui_cell(image: Image, rect: Rect2i, cell_x: int, cell_y: int) -> void:
	var base_color := GRAPHITE
	match cell_y:
		0:
			base_color = GRAPHITE
		1:
			base_color = BROWN
		2:
			base_color = BLUEGRAY
		_:
			base_color = STONE
	_fill_rect(image, rect, base_color.darkened(0.28))
	_fill_gradient(image, rect.grow(-4), base_color)
	_draw_border(image, rect, cell_y)

	match Vector2i(cell_x, cell_y):
		Vector2i(0, 0):
			_draw_bar_frame(image, rect, DAMAGE_LIGHT, DAMAGE)
		Vector2i(1, 0):
			_draw_bar_fill(image, rect, DAMAGE_LIGHT, DAMAGE, true)
		Vector2i(2, 0):
			_draw_bar_frame(image, rect, BLUEGRAY_LIGHT, BLUEGRAY)
		Vector2i(3, 0):
			_draw_bar_fill(image, rect, HEAL_LIGHT, HEAL, false)
		Vector2i(0, 1):
			_draw_attack_icon(image, rect, FURNACE_LIGHT, false)
		Vector2i(1, 1):
			_draw_attack_icon(image, rect, FURNACE, true)
		Vector2i(2, 1):
			_draw_dodge_icon(image, rect)
		Vector2i(3, 1):
			_draw_interact_icon(image, rect)
		Vector2i(0, 2):
			_draw_heal_icon(image, rect)
		Vector2i(1, 2):
			_draw_pause_icon(image, rect)
		Vector2i(2, 2):
			_draw_checkpoint_icon(image, rect)
		Vector2i(3, 2):
			_draw_save_icon(image, rect)
		Vector2i(0, 3):
			_draw_inventory_icon(image, rect)
		Vector2i(1, 3):
			_draw_journal_icon(image, rect)
		Vector2i(2, 3):
			_draw_corner_glow(image, rect, FURNACE_LIGHT, HEAL_LIGHT)
		Vector2i(3, 3):
			_draw_corner_glow(image, rect, BLUEGRAY_LIGHT, ASH)


func _draw_border(image: Image, rect: Rect2i, row: int) -> void:
	var top := FURNACE_LIGHT if row == 1 else BLUEGRAY_LIGHT
	_fill_rect(image, Rect2i(rect.position.x, rect.position.y, rect.size.x, 2), top.darkened(0.15))
	_fill_rect(image, Rect2i(rect.position.x, rect.position.y, 2, rect.size.y), ASH.lightened(0.02))
	_fill_rect(image, Rect2i(rect.position.x + rect.size.x - 2, rect.position.y, 2, rect.size.y), GRAPHITE_DARK)
	_fill_rect(image, Rect2i(rect.position.x, rect.position.y + rect.size.y - 2, rect.size.x, 2), GRAPHITE_DARK)
	_plot_thick(image, rect.position.x + 4, rect.position.y + 4, 1, ASH)
	_plot_thick(image, rect.position.x + rect.size.x - 5, rect.position.y + 4, 1, ASH)
	_plot_thick(image, rect.position.x + 4, rect.position.y + rect.size.y - 5, 1, GRAPHITE_LIGHT)
	_plot_thick(image, rect.position.x + rect.size.x - 5, rect.position.y + rect.size.y - 5, 1, GRAPHITE_LIGHT)


func _draw_bar_frame(image: Image, rect: Rect2i, glow: Color, fill: Color) -> void:
	var inner := rect.grow(-8)
	_fill_rect(image, inner, GRAPHITE_DARK)
	_fill_rect(image, Rect2i(inner.position.x, inner.position.y, inner.size.x, 3), glow.darkened(0.2))
	_fill_rect(image, Rect2i(inner.position.x, inner.position.y + inner.size.y - 3, inner.size.x, 3), GRAPHITE_LIGHT)
	_draw_runes(image, inner, glow, false)


func _draw_bar_fill(image: Image, rect: Rect2i, light: Color, dark: Color, damaged: bool) -> void:
	var inner := rect.grow(-8)
	for y in range(inner.position.y, inner.position.y + inner.size.y):
		var t: float = float(y - inner.position.y) / max(1.0, float(inner.size.y - 1))
		var color: Color = light.lerp(dark, t)
		color = color.lightened(0.04) if not damaged else color.darkened(0.03)
		for x in range(inner.position.x, inner.position.x + inner.size.x):
			var edge: int = min(x - inner.position.x, inner.position.x + inner.size.x - 1 - x)
			var c: Color = color
			if edge <= 1:
				c = c.lightened(0.08)
			image.set_pixel(x, y, c)
	if damaged:
		_fill_rect(image, Rect2i(inner.position.x + 8, inner.position.y + 18, inner.size.x - 16, 6), DAMAGE.darkened(0.1))
		_fill_rect(image, Rect2i(inner.position.x + 14, inner.position.y + 30, inner.size.x - 22, 4), DAMAGE_LIGHT.darkened(0.2))


func _draw_attack_icon(image: Image, rect: Rect2i, color: Color, heavy: bool) -> void:
	var center := rect.position + Vector2i(32, 32)
	var length := 24 if heavy else 19
	for i in range(-length, length):
		var x := center.x + i
		var y := center.y - int(float(i) * (0.40 if heavy else 0.36))
		_plot_thick(image, x, y, 2 if heavy else 1, color)
	_plot_thick(image, center.x - 16, center.y + 10, 4, BROWN_LIGHT)
	_plot_thick(image, center.x - 11, center.y + 13, 2, GRAPHITE)
	for offset in range(-3, 4):
		_plot_thick(image, center.x + 10 + offset, center.y - 10 + offset / 2, 1, ASH)


func _draw_dodge_icon(image: Image, rect: Rect2i) -> void:
	var base := rect.position + Vector2i(32, 32)
	for i in range(16):
		_plot_thick(image, base.x - 18 + i, base.y + 7 - int(i * 0.45), 2, BLUEGRAY_LIGHT)
		_plot_thick(image, base.x + 5 + i, base.y - 15 + int(i * 0.18), 2, HEAL_LIGHT)
	_plot_thick(image, base.x - 4, base.y - 20, 2, ASH)
	_plot_thick(image, base.x - 10, base.y + 14, 2, FURNACE_LIGHT)


func _draw_interact_icon(image: Image, rect: Rect2i) -> void:
	var center := rect.position + Vector2i(32, 32)
	_draw_circle(image, center, 14, BLUEGRAY_LIGHT)
	_draw_circle(image, center, 11, GRAPHITE_DARK)
	_fill_rect(image, Rect2i(center.x - 2, center.y - 6, 4, 12), ASH)
	_fill_rect(image, Rect2i(center.x - 6, center.y - 2, 12, 4), ASH)
	_fill_rect(image, Rect2i(center.x - 1, center.y - 12, 2, 4), FURNACE_LIGHT)


func _draw_heal_icon(image: Image, rect: Rect2i) -> void:
	var center := rect.position + Vector2i(32, 32)
	_fill_rect(image, Rect2i(center.x - 3, center.y - 12, 6, 24), HEAL_LIGHT)
	_fill_rect(image, Rect2i(center.x - 12, center.y - 3, 24, 6), HEAL_LIGHT)
	_draw_circle(image, center, 13, HEAL.darkened(0.15))


func _draw_pause_icon(image: Image, rect: Rect2i) -> void:
	var base := rect.position + Vector2i(32, 32)
	_fill_rect(image, Rect2i(base.x - 10, base.y - 16, 5, 32), ASH)
	_fill_rect(image, Rect2i(base.x + 5, base.y - 16, 5, 32), ASH)
	_fill_rect(image, Rect2i(base.x - 12, base.y - 18, 29, 2), FURNACE_LIGHT)
	_fill_rect(image, Rect2i(base.x - 12, base.y + 16, 29, 2), BLUEGRAY_LIGHT)


func _draw_checkpoint_icon(image: Image, rect: Rect2i) -> void:
	var center := rect.position + Vector2i(32, 32)
	_draw_circle(image, center, 15, FURNACE_LIGHT)
	_draw_circle(image, center, 11, GRAPHITE_DARK)
	_fill_rect(image, Rect2i(center.x - 2, center.y - 11, 4, 18), FURNACE_LIGHT)
	_fill_rect(image, Rect2i(center.x - 8, center.y - 3, 16, 4), FURNACE_LIGHT)


func _draw_save_icon(image: Image, rect: Rect2i) -> void:
	var origin := rect.position + Vector2i(18, 16)
	_fill_rect(image, Rect2i(origin.x, origin.y, 28, 32), STONE_LIGHT)
	_fill_rect(image, Rect2i(origin.x + 4, origin.y + 4, 20, 10), BLUEGRAY)
	_fill_rect(image, Rect2i(origin.x + 8, origin.y + 18, 12, 10), GRAPHITE_DARK)
	_fill_rect(image, Rect2i(origin.x + 22, origin.y + 4, 4, 12), FURNACE_LIGHT)


func _draw_inventory_icon(image: Image, rect: Rect2i) -> void:
	var base := rect.position + Vector2i(20, 18)
	_fill_rect(image, Rect2i(base.x, base.y, 24, 28), BROWN)
	_fill_rect(image, Rect2i(base.x + 2, base.y + 2, 20, 6), BROWN_LIGHT)
	_fill_rect(image, Rect2i(base.x + 8, base.y + 12, 8, 14), GRAPHITE_DARK)
	_fill_rect(image, Rect2i(base.x + 4, base.y + 22, 16, 4), FURNACE_LIGHT)


func _draw_journal_icon(image: Image, rect: Rect2i) -> void:
	var base := rect.position + Vector2i(18, 16)
	_fill_rect(image, Rect2i(base.x, base.y, 28, 32), BLUEGRAY)
	_fill_rect(image, Rect2i(base.x + 4, base.y + 4, 20, 24), GRAPHITE_DARK)
	_fill_rect(image, Rect2i(base.x + 2, base.y + 6, 4, 20), FURNACE_LIGHT)
	_fill_rect(image, Rect2i(base.x + 8, base.y + 9, 14, 2), ASH)
	_fill_rect(image, Rect2i(base.x + 8, base.y + 15, 14, 2), ASH_DARK)


func _draw_corner_glow(image: Image, rect: Rect2i, light: Color, dark: Color) -> void:
	var center := rect.position + Vector2i(32, 32)
	for radius in range(20, 0, -1):
		var t := float(radius) / 20.0
		var color := dark.lerp(light, t)
		color.a = 0.18 * t
		_draw_circle(image, center, radius, color)


func _draw_runes(image: Image, rect: Rect2i, color: Color, vertical: bool) -> void:
	var y := rect.position.y + 8
	while y < rect.position.y + rect.size.y - 8:
		var x := rect.position.x + 8
		while x < rect.position.x + rect.size.x - 8:
			_plot(image, x, y, color)
			if vertical:
				_plot(image, x + 1, y + 1, color.lightened(0.1))
			else:
				_plot(image, x + 1, y, color.lightened(0.1))
			x += 18
		y += 18


func _fill_gradient(image: Image, rect: Rect2i, base: Color) -> void:
	for y in range(rect.position.y, rect.position.y + rect.size.y):
		var t: float = float(y - rect.position.y) / max(1.0, float(rect.size.y - 1))
		var color: Color = base.lightened(0.06 - t * 0.08)
		for x in range(rect.position.x, rect.position.x + rect.size.x):
			image.set_pixel(x, y, color)


func _fill_rect(image: Image, rect: Rect2i, color: Color) -> void:
	for y in range(rect.position.y, rect.position.y + rect.size.y):
		for x in range(rect.position.x, rect.position.x + rect.size.x):
			_plot(image, x, y, color)


func _plot(image: Image, x: int, y: int, color: Color) -> void:
	if x < 0 or y < 0 or x >= image.get_width() or y >= image.get_height():
		return
	image.set_pixel(x, y, color)


func _plot_thick(image: Image, x: int, y: int, radius: int, color: Color) -> void:
	for oy in range(-radius, radius + 1):
		for ox in range(-radius, radius + 1):
			if abs(ox) + abs(oy) <= radius + 1:
				_plot(image, x + ox, y + oy, color)


func _draw_circle(image: Image, center: Vector2i, radius: int, color: Color) -> void:
	for y in range(center.y - radius, center.y + radius + 1):
		for x in range(center.x - radius, center.x + radius + 1):
			if Vector2i(x, y).distance_to(center) <= float(radius):
				_plot(image, x, y, color)


func _save_image(image: Image, generated_path: String, runtime_path: String) -> void:
	var generated_abs := ProjectSettings.globalize_path(generated_path)
	var runtime_abs := ProjectSettings.globalize_path(runtime_path)
	image.save_png(generated_abs)
	image.save_png(runtime_abs)
