extends Control

@onready var play_button = %PlayButton

signal edit_details
signal add_to_blacklist(game : Game)
signal edit_tags

func _refresh_from_data(selected : Game) -> void:
	%Name.text = selected.name
	%Year.text = str(selected.year)
	%Developer.text = selected.developer
	%TagsList.clear()
	for tag in selected.tags:
		%TagsList.add_item(tag)
	%FilePath.set_text("[i]" + selected.path)

func _on_edit_button_pressed() -> void:
	edit_details.emit()

func _on_blacklist_button_pressed() -> void:
	add_to_blacklist.emit()


func _on_tag_button_pressed() -> void:
	edit_tags.emit()
