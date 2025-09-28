extends Control

@onready var search_bar = %SearchBar
@onready var tags_list = %TagsList
@onready var tag_button = %TagButton
@onready var image_toggle = %ImageDisplay

var tags
var selected_tags : Array[String]
signal tags_changed(tags)

func load_tags(_tags : Array[String]) -> void:
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
