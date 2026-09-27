extends Control

@onready var search_bar := %SearchBar as LineEdit
@onready var tags_list := %TagsList as PopupMenu
@onready var tag_button := %TagButton as FontIconButton
@onready var image_toggle := %ImageDisplay as FontIconCheckButton
@onready var sort_type := %SortType as OptionButton
@onready var sort_button := %SortButton as FontIconCheckButton
@onready var list_mode_toggle := %ListMode as FontIconCheckButton
@onready var count := %Count as Label
@onready var total_count := %Total as Label

var tags : Array = []
var selected_tags : PackedStringArray

var invert_sort : bool = false

signal tags_changed(tags)
signal sort_changed(keep_selected)

func _ready() -> void:
	list_mode_toggle.button_pressed = Global.library_list_mode
	image_toggle.button_pressed = not Global.library_display_images
	sort_type.get_popup().mouse_exited.connect(
		func():
			sort_type.get_popup().set_visible(false)
			sort_type.set_pressed_no_signal(false)
			get_viewport().gui_release_focus()
	)
	
	tags_list.mouse_exited.connect(
		func():
			tags_list.hide()
			get_viewport().gui_release_focus()
	)

func load_tags(_tags : PackedStringArray) -> void:
	tags = _tags
	update_tag_display_list()

func _on_tag_button_pressed() -> void:
	if !tags_list.visible:
		tags_list.show()
		tags_list.position = get_window().position + Vector2i(253,70)
	else:
		tags_list.hide()

func update_tag_display_list() -> void:
	tags_list.clear()
	if tags.is_empty():
		tag_button.hide()
	else: 
		tag_button.show()
	for index in tags.size():
		tags_list.add_check_item(tags[index],index)
		if selected_tags.has(tags_list.get_item_text(index)):
			tags_list.set_item_checked(index, true)
		
	tags_list.reset_size()

func _on_tags_list_index_pressed(index: int) -> void:
	tags_list.toggle_item_checked(index)
	if tags_list.is_item_checked(index):
		selected_tags.append(tags_list.get_item_text(index))
		tags_changed.emit(selected_tags)
	else:
		selected_tags.remove_at(selected_tags.find(tags_list.get_item_text(index)))
		tags_changed.emit(selected_tags)

func _on_sort_type_item_selected(_index: int) -> void:
	sort_changed.emit(true)


func _on_image_display_toggled(value: bool) -> void:
	Global.library_display_images = not value


func _on_list_mode_toggled(value: bool) -> void:
	Global.library_list_mode = value


func _on_visibility_changed() -> void:
	if list_mode_toggle: list_mode_toggle.button_pressed = Global.library_list_mode
	if image_toggle: image_toggle.button_pressed = not Global.library_display_images


func _on_sort_button_toggled(_value: bool) -> void:
	invert_sort = not invert_sort
	sort_changed.emit(true)


func _on_tags_changed(_tags: Variant) -> void:
	tag_button.icon_settings.icon_color = Color(1.0, 1.0, 1.0, 1.0)
	if selected_tags: tag_button.icon_settings.icon_color = Color(0.498, 0.777, 1.0, 1.0)
		
