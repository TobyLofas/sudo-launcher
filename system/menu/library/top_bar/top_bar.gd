extends Control

@onready var search_bar = %SearchBar
@onready var tags_list = %TagsList
@onready var tag_button = %TagButton
@onready var image_toggle = %ImageDisplay

var selected_tags : Array[String]
signal tags_changed(tags)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tags_list.id_pressed.connect(_on_tags_list_pressed)

func load_tags(_tags : Array[String]) -> void:
	pass

func _on_tags_list_pressed(id : int) -> void:
	if tags_list.is_item_checked(id):
		selected_tags.append(tags_list.get_item_text(id))
		tags_changed.emit(selected_tags)
	else:
		selected_tags.remove_at(selected_tags.find(tags_list.get_item_text(id)))
		tags_changed.emit(selected_tags)

func _on_tag_button_pressed() -> void:
	tags_list.position.x = tag_button.position.x
	tags_list.position.y = tag_button.position.y + (tags_list.item_count * 35)
	tags_list.show()
