extends Control
class_name InventoryPanel

@onready var background: Node = $Panel
@onready var title_label: Label = $Panel/VBox/TitleLabel
@onready var list: ItemList = $Panel/VBox/Content/ItemList
@onready var icon: TextureRect = $Panel/VBox/Content/Details/Icon
@onready var name_label: Label = $Panel/VBox/Content/Details/NameLabel
@onready var quantity_label: Label = $Panel/VBox/Content/Details/QuantityLabel
@onready var description: RichTextLabel = $Panel/VBox/Description
@onready var equip_button: Button = $Panel/VBox/Buttons/EquipButton
@onready var close_button: Button = $Panel/VBox/Buttons/CloseButton
@onready var use_button: Button = $Panel/VBox/Buttons/UseButton

const ITEM_ICON_REGIONS := {
	"rusty_knife": Rect2i(0, 0, 32, 32),
	"miner_blade": Rect2i(1, 0, 32, 32),
	"healing_herb": Rect2i(2, 0, 32, 32),
	"key": Rect2i(3, 0, 32, 32),
	"living_stone_fragment": Rect2i(0, 1, 32, 32),
	"note": Rect2i(1, 1, 32, 32),
	"lantern": Rect2i(2, 1, 32, 32),
	"quest_seal": Rect2i(3, 1, 32, 32),
}

var _selected_index: int = -1


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	title_label.text = "Инвентарь"
	use_button.text = "Использовать"
	equip_button.text = "Снарядить"
	close_button.text = "Закрыть"
	close_button.pressed.connect(hide_panel)
	use_button.pressed.connect(_use_selected_item)
	equip_button.pressed.connect(_equip_selected_item)
	list.item_selected.connect(_on_item_selected)
	_set_skin()
	refresh()


func toggle_panel() -> void:
	visible = not visible
	if visible:
		refresh()


func hide_panel() -> void:
	visible = false


func refresh() -> void:
	list.clear()
	var items: Array = GameState.inventory_snapshot
	if items.is_empty():
		list.add_item("Инвентарь пуст")
		_show_item_details({})
		return
	var preserve_index := _selected_index
	_selected_index = -1
	for entry_variant in items:
		if not (entry_variant is Dictionary):
			continue
		var entry: Dictionary = entry_variant
		var item_data := _load_item_data(String(entry.get("id", "")))
		var label := "%s x%d" % [
			String(entry.get("name", item_data.get("name", "Неизвестно"))),
			int(entry.get("quantity", 1))
		]
		list.add_item(label)
	var item_count := list.get_item_count()
	if preserve_index >= 0 and preserve_index < item_count:
		_selected_index = preserve_index
		list.select(_selected_index)
		_on_item_selected(_selected_index)
	elif item_count > 0:
		_selected_index = 0
		list.select(0)
		_on_item_selected(0)
	else:
		_show_item_details({})


func _on_item_selected(index: int) -> void:
	_selected_index = index
	var items: Array = GameState.inventory_snapshot
	if index < 0 or index >= items.size():
		_show_item_details({})
		return
	var item: Dictionary = items[index]
	_show_item_details(item)


func _use_selected_item() -> void:
	if _selected_index < 0:
		return
	var items: Array = GameState.inventory_snapshot
	if _selected_index >= items.size():
		return
	var item: Dictionary = items[_selected_index]
	var item_id := String(item.get("id", ""))
	if item_id == "healing_herb" and GameState.consume_inventory_item("healing_herb", 1):
		if GameState.current_player != null and GameState.current_player.has_method("heal"):
			GameState.current_player.call("heal", 4)
		refresh()
		description.text = "Трава использована."
	elif item_id != "":
		description.text = "Этот предмет пока нельзя использовать."


func _equip_selected_item() -> void:
	if _selected_index < 0:
		return
	var items: Array = GameState.inventory_snapshot
	if _selected_index >= items.size():
		return
	var item: Dictionary = items[_selected_index]
	var item_id := String(item.get("id", ""))
	if item_id == "":
		return
	GameState.settings["equipped_item_id"] = item_id
	GameState.settings["equipped_item_name"] = String(item.get("name", _load_item_data(item_id).get("name", "")))
	_show_item_details(item)


func _show_item_details(entry: Dictionary) -> void:
	if entry.is_empty():
		icon.texture = null
		name_label.text = "Предмет не выбран"
		quantity_label.text = "Количество: 0"
		description.text = "Выберите предмет."
		return
	var item_id := String(entry.get("id", ""))
	var item_data := _load_item_data(item_id)
	var display_name := String(entry.get("name", item_data.get("name", "Неизвестно")))
	var description_text := String(entry.get("description", item_data.get("description", "")))
	var icon_id := String(entry.get("icon_id", item_data.get("icon_id", "")))
	var quantity := int(entry.get("quantity", 1))
	icon.texture = _load_item_icon(icon_id)
	if GameState.settings.get("equipped_item_id", "") == item_id:
		display_name = "%s [снаряжён]" % display_name
	name_label.text = display_name
	quantity_label.text = "Количество: %d" % quantity
	description.text = description_text if description_text != "" else "Описание появится позже."


func _load_item_data(item_id: String) -> Dictionary:
	if item_id.strip_edges() == "":
		return {}
	var path := "res://data/items/%s.json" % item_id
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		return parsed as Dictionary
	return {}


func _load_item_icon(icon_id: String) -> Texture2D:
	if icon_id.strip_edges() == "":
		return null
	var texture_path := AssetCatalog.resolve_path(icon_id)
	if texture_path == "":
		return null
	var texture := load(texture_path) as Texture2D
	if texture == null:
		return null
	var item_id := icon_id.get_slice(".", 1)
	var region: Rect2i = ITEM_ICON_REGIONS.get(item_id, Rect2i())
	if region.size == Vector2i.ZERO:
		return texture
	var atlas_texture := AtlasTexture.new()
	atlas_texture.atlas = texture
	atlas_texture.region = Rect2(float(region.position.x), float(region.position.y), float(region.size.x), float(region.size.y))
	return atlas_texture

func _set_skin() -> void:
	background.set("texture", AssetCatalog.texture("ui.panel.inventory"))
