extends Control

@onready var play_button = %PlayButton
@onready var stop_button = %StopButton
@onready var _tags_list = %TagsList

signal edit_details
signal add_to_blacklist(game : Game)
signal edit_tags
signal tag_selected(tag : String)
signal refreshed

func _refresh_from_data(selected : Game) -> void:
	reset_data()
	if not selected: return
	%Name.text = selected.name
	%Year.text = str(selected.year)
	if selected.year == 0: %Year.text = ""
	%Developer.text = selected.developer
	_tags_list.clear()
	for tag in selected.tags:
		_tags_list.add_item(tag)
	%FilePath.set_text("[i]" + selected.path)
	if not Global.detail_panel_show_icon: %DetailIcon.hide()
	else: 
		var icon
		if selected.icon == Global.default_icon_path:
			icon = Global.default_icon
		else:
			var index = selected.icon_cache_index
			if index < 0:
				var image_path = selected.icon
				var image = Image.load_from_file(image_path)
				if not image:
					image = Image.load_from_file(Global.default_icon_path) ##will warning - but works as a fallback for now
				image.resize(Global.detail_icon_size,Global.detail_icon_size,Image.INTERPOLATE_NEAREST)
				icon = ImageTexture.create_from_image(image)
			else:
				icon = Global.image_cache[index]
		icon.set_size_override(Vector2i(Global.detail_icon_size,Global.detail_icon_size))
		%DetailIcon.texture = icon
		%DetailIcon.texture_filter = Global.detail_icon_filter + 1 ##Offset to account for godot inherit from parent
		%DetailIcon.custom_minimum_size = Vector2i(Global.detail_icon_size, Global.detail_icon_size)
		%DetailIcon.show()
		
	if selected.pid > 0:
		var monitors = get_tree().get_nodes_in_group(&"Monitors")
		if monitors:
			for monitor in monitors:
				if monitor.pid == selected.pid and monitor.pid != -1:
					play_button.hide()
					stop_button.show()
	else:
		play_button.show()
		stop_button.hide()
	
	refreshed.emit()

func _on_edit_button_pressed() -> void:
	edit_details.emit()

func _on_blacklist_button_pressed() -> void:
	%ConfirmationDialog.show()
	

func _on_tag_button_pressed() -> void:
	edit_tags.emit()


func _on_confirmation_dialog_confirmed() -> void:
	add_to_blacklist.emit()


func _on_tags_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:
	var text = _tags_list.get_item_text(index)
	tag_selected.emit(text)

func reset_data() -> void:
	%Name.text = "TITLE"
	%Year.text = ""
	%Developer.text = ""
	_tags_list.clear()
	%FilePath.set_text("")
	%DetailIcon.hide()
	play_button.hide()
	stop_button.hide()
