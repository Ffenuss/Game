extends RefCounted
class_name UIStyle

const FONT_PRIMARY := Color(0.96, 0.97, 0.98, 1.0)
const FONT_SECONDARY := Color(0.87, 0.90, 0.93, 1.0)
const FONT_MUTED := Color(0.66, 0.70, 0.74, 1.0)

const PANEL_BG := Color(0.05, 0.06, 0.08, 0.90)
const PANEL_BORDER := Color(0.23, 0.27, 0.32, 0.92)
const PANEL_BORDER_ACCENT := Color(0.48, 0.34, 0.20, 0.95)

const ACCENT_FIRE := Color(0.72, 0.44, 0.18, 1.0)
const ACCENT_HEAVY := Color(0.56, 0.37, 0.22, 1.0)
const ACCENT_FOG := Color(0.39, 0.50, 0.58, 1.0)
const ACCENT_HEAL := Color(0.34, 0.56, 0.35, 1.0)
const ACCENT_ASH := Color(0.28, 0.32, 0.38, 1.0)


func apply_panel(panel: NinePatchRect, asset_id: String = "", alpha: float = 0.92, tint: Color = Color.WHITE) -> void:
	if panel == null:
		return
	if asset_id != "":
		var texture := AssetCatalog.texture(asset_id)
		if texture != null:
			panel.texture = texture
	panel.modulate = Color(tint.r, tint.g, tint.b, alpha)


func apply_button(button: Button, accent: Color = ACCENT_ASH, font_size: int = 10, icon: Texture2D = null) -> void:
	if button == null:
		return
	if icon != null:
		button.icon = icon
		button.expand_icon = true
	button.focus_mode = Control.FOCUS_NONE
	button.clip_text = true
	button.add_theme_font_size_override("font_size", font_size)
	button.add_theme_color_override("font_color", FONT_PRIMARY)
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.96, 0.88, 1.0))
	button.add_theme_color_override("font_pressed_color", Color(1.0, 0.91, 0.74, 1.0))
	button.add_theme_color_override("font_disabled_color", FONT_MUTED)
	button.add_theme_stylebox_override("normal", _make_button_box(Color(0.07, 0.08, 0.10, 0.78), accent))
	button.add_theme_stylebox_override("hover", _make_button_box(Color(0.09, 0.10, 0.13, 0.88), accent.lightened(0.12)))
	button.add_theme_stylebox_override("pressed", _make_button_box(Color(0.14, 0.10, 0.07, 0.96), accent.lightened(0.26)))
	button.add_theme_stylebox_override("disabled", _make_button_box(Color(0.04, 0.05, 0.06, 0.60), ACCENT_ASH.darkened(0.15)))


func apply_label(label: Label, font_size: int = 14, color: Color = FONT_PRIMARY, centered: bool = false) -> void:
	if label == null:
		return
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	if centered:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER


func apply_rich_label(label: RichTextLabel, color: Color = FONT_SECONDARY) -> void:
	if label == null:
		return
	label.add_theme_color_override("default_color", color)


func apply_item_list(item_list: ItemList) -> void:
	if item_list == null:
		return
	item_list.add_theme_stylebox_override("panel", _make_card_box(Color(0.05, 0.06, 0.08, 0.88), PANEL_BORDER))
	item_list.add_theme_color_override("font_color", FONT_SECONDARY)
	item_list.add_theme_color_override("font_selected_color", FONT_PRIMARY)
	item_list.add_theme_color_override("font_hover_color", FONT_PRIMARY)


func apply_text_panel(panel: NinePatchRect, asset_id: String, alpha: float = 0.92) -> void:
	apply_panel(panel, asset_id, alpha)


func apply_progress_bars(under_bar: TextureProgressBar, progress_bar: TextureProgressBar, frame_id: String, fill_id: String) -> void:
	if under_bar != null:
		under_bar.texture_under = AssetCatalog.texture(frame_id)
	if progress_bar != null:
		progress_bar.texture_progress = AssetCatalog.texture(fill_id)


func _make_button_box(bg: Color, border: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = bg
	box.border_color = border
	box.border_width_left = 1
	box.border_width_top = 1
	box.border_width_right = 1
	box.border_width_bottom = 1
	box.corner_radius_top_left = 8
	box.corner_radius_top_right = 8
	box.corner_radius_bottom_left = 8
	box.corner_radius_bottom_right = 8
	box.content_margin_left = 5
	box.content_margin_top = 2
	box.content_margin_right = 5
	box.content_margin_bottom = 2
	return box


func _make_card_box(bg: Color, border: Color) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = bg
	box.border_color = border
	box.border_width_left = 1
	box.border_width_top = 1
	box.border_width_right = 1
	box.border_width_bottom = 1
	box.corner_radius_top_left = 10
	box.corner_radius_top_right = 10
	box.corner_radius_bottom_left = 10
	box.corner_radius_bottom_right = 10
	box.content_margin_left = 6
	box.content_margin_top = 4
	box.content_margin_right = 6
	box.content_margin_bottom = 4
	return box
