extends Control

@onready var play_button = %PlayButton

signal edit_details
signal add_to_blacklist(game : Game)
signal edit_tags

func _refresh_from_data(selected : Game) -> void:
	if not selected: return
	%Name.text = selected.name
	%Year.text = str(selected.year)
	%Developer.text = selected.developer
	%TagsList.clear()
	for tag in selected.tags:
		%TagsList.add_item(tag)
	%FilePath.set_text("[i]" + selected.path)
	if not Global.detail_panel_show_icon: %DetailIcon.hide()
	else: 
		var icon
		if selected.icon.contains("res://"):
			icon = load(selected.icon)
		else:
			var image
			var image_path = selected.icon
			image = Image.new()
			var error = image.load(image_path)
			if error:
				selected.icon = Global.default_icon_path
				icon = load(selected.icon)
			else:
				icon = ImageTexture.new()
				icon.set_image(image)
		%DetailIcon.texture = icon
		%DetailIcon.show()

func _on_edit_button_pressed() -> void:
	edit_details.emit()

func _on_blacklist_button_pressed() -> void:
	%ConfirmationDialog.show()
	

func _on_tag_button_pressed() -> void:
	edit_tags.emit()


func _on_confirmation_dialog_confirmed() -> void:
	add_to_blacklist.emit()
