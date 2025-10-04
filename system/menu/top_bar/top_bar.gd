extends Control

@onready var search_bar = %SearchBar
@onready var tags_list = %TagsList
@onready var tag_button = %TagButton
@onready var image_toggle = %ImageDisplay
@onready var sort_type = %SortType
@onready var sort_button = %SortButton
@onready var list_mode_toggle = %ListMode

var tags = []
var selected_tags : Array[String]

var invert_sort : bool = false

signal tags_changed(tags)
signal sort_changed

func _ready() -> void:
	list_mode_toggle.button_pressed = Global.library_list_mode
	image_toggle.button_pressed = not Global.library_display_images

func load_tags(_tags : Array[String]) -> void:
	tags.clear()
	tags = _tags
	update_tag_display_list()

func _on_tag_button_pressed() -> void:
	if !tags_list.visible:
		tags_list.position.x = tag_button.position.x
		tags_list.position.y = tag_button.position.y + 70
		tags_list.show()
	else:
		tags_list.hide()

func update_tag_display_list() -> void:
	if tags.is_empty():
		tag_button.hide()
	else: 
		tag_button.show()
	for index in len(tags):
		tags_list.add_check_item(tags[index],index)

func _on_tags_list_index_pressed(index: int) -> void:
	tags_list.toggle_item_checked(index)
	if tags_list.is_item_checked(index):
		selected_tags.append(tags_list.get_item_text(index))
		tags_changed.emit(selected_tags)
	else:
		selected_tags.remove_at(selected_tags.find(tags_list.get_item_text(index)))
		tags_changed.emit(selected_tags)

func _on_sort_button_pressed() -> void:
	invert_sort = not invert_sort
	sort_changed.emit()

func _on_sort_type_item_selected(_index: int) -> void:
	sort_changed.emit()


func _on_image_display_toggled(value: bool) -> void:
	Global.library_display_images = not value


func _on_list_mode_toggled(value: bool) -> void:
	Global.library_list_mode = value


func _on_visibility_changed() -> void:
	list_mode_toggle.button_pressed = Global.library_list_mode
	image_toggle.button_pressed = not Global.library_display_images
