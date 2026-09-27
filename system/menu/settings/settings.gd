extends Control

signal highlight_colour_changed

func _ready() -> void:
	%VersionLabel.text = ProjectSettings.get_setting("application/config/version")
	%Divider.split_offset = Global.settings_divider_offset

func _on_list_mode_toggled(toggled_on: bool) -> void:
	Global.library_list_mode = toggled_on
	#Global.save_settings()

func _on_open_to_last_toggled(toggled_on: bool) -> void:
	Global.library_open_to_last_selected = toggled_on
	#Global.save_settings()

func _on_show_icons_toggled(toggled_on: bool) -> void:
	Global.library_display_images = toggled_on
	#Global.save_settings()

func _on_visibility_changed() -> void:
	%ListMode.button_pressed = Global.library_list_mode
	%OpenToLast.button_pressed = Global.library_open_to_last_selected
	%ShowIcons.button_pressed = Global.library_display_images
	%DetailIcon.button_pressed = Global.detail_panel_show_icon
	%PreserveScroll.button_pressed = Global.library_preserve_scroll
	%FullscreenMode.button_pressed = Global.window_preserve_mode
	%ColumnIconSize.text = str(Global.column_icon_size)
	%GridIconSize.text = str(Global.grid_icon_size)
	%DetailIconSize.text = str(Global.detail_icon_size)
	%FontSize.text = str(Global.library_font_size)
	%GridText.button_pressed = Global.library_grid_text
	%LibraryFilter.selected = Global.library_icon_filter
	%DetailFilter.selected = Global.detail_icon_filter
	%GridFontSize.text = str(Global.grid_font_size)
	%ListTextTrim.selected = Global.list_text_trim
	%GridTextTrim.selected = Global.grid_text_trim
	
	var highlight_colour : Color = Color(Global.top_bar_highlight_colour)
	%HighlightColorPicker.color = highlight_colour
	%HighlightButton.add_theme_color_override("icon_normal_color", highlight_colour)
	%HighlightButton.add_theme_color_override("icon_hover_color", highlight_colour)
	%HighlightButton.add_theme_color_override("icon_pressed_color", highlight_colour)
	%HighlightButton.add_theme_color_override("icon_hover_pressed_color", highlight_colour)
	
	var running_colour : Color = Color(Global.running_game_colour)
	%RunningColorPicker.color = running_colour
	%RunningColourButton.add_theme_color_override("icon_normal_color", running_colour)
	%RunningColourButton.add_theme_color_override("icon_hover_color", running_colour)
	%RunningColourButton.add_theme_color_override("icon_pressed_color", running_colour)
	%RunningColourButton.add_theme_color_override("icon_hover_pressed_color", running_colour)

func _on_detail_icon_toggled(toggled_on: bool) -> void:
	Global.detail_panel_show_icon = toggled_on

func _on_preserve_scroll_toggled(toggled_on: bool) -> void:
	Global.library_preserve_scroll = toggled_on

func _on_fullscreen_mode_toggled(toggled_on: bool) -> void:
	Global.window_preserve_mode = toggled_on

func _on_column_icon_size_text_changed(new_text: String) -> void:
	Global.column_icon_size = new_text.to_int()

func _on_grid_icon_size_text_changed(new_text: String) -> void:
	Global.grid_icon_size = new_text.to_int()

func _on_detail_icon_size_text_changed(new_text: String) -> void:
	Global.detail_icon_size = new_text.to_int()

func _on_font_size_text_changed(new_text: String) -> void:
	Global.library_font_size = new_text.to_int()

func _on_grid_text_toggled(toggled_on: bool) -> void:
	Global.library_grid_text = toggled_on

func _on_library_filter_item_selected(index: int) -> void:
	Global.library_icon_filter = index

func _on_detail_filter_item_selected(index: int) -> void:
	Global.detail_icon_filter = index

func _on_grid_font_size_text_changed(new_text: String) -> void:
	Global.grid_font_size = new_text.to_int()

func _on_list_text_trim_item_selected(index: int) -> void:
	Global.list_text_trim = index

func _on_grid_text_trim_item_selected(index: int) -> void:
	Global.grid_text_trim = index

func _on_show_license_toggled(toggled_on: bool) -> void:
	if toggled_on: %LicensePopup.show()
	else: %LicensePopup.hide()

func _on_license_popup_hide() -> void:
	%ShowLicense.button_pressed = false


func _on_highlight_popup_hide() -> void:
	%HighlightButton.button_pressed = false

func _on_highlight_button_toggled(toggled_on: bool) -> void:
	if toggled_on: 
		%HighlightPopup.show()
		%HighlightPopup.position = Global.get_center_position(%HighlightPopup)
	else: %HighlightPopup.hide()


func _on_highlight_color_picker_color_changed(color: Color) -> void:
	%HighlightButton.add_theme_color_override("icon_normal_color", color)
	%HighlightButton.add_theme_color_override("icon_hover_color", color)
	%HighlightButton.add_theme_color_override("icon_pressed_color", color)
	%HighlightButton.add_theme_color_override("icon_hover_pressed_color", color)
	Global.top_bar_highlight_colour = color.to_html()
	highlight_colour_changed.emit()


func _on_running_colour_button_toggled(toggled_on: bool) -> void:
	if toggled_on: 
		%RunningColourPopup.show()
		%RunningColourPopup.position = Global.get_center_position(%RunningColourPopup)
	else: %RunningColourPopup.hide()


func _on_highlight_popup_mouse_exited() -> void:
	#%HighlightPopup.hide()
	#%HighlightButton.set_pressed_no_signal(false)
	pass


func _on_running_color_changed(color: Color) -> void:
	%RunningColourButton.add_theme_color_override("icon_normal_color", color)
	%RunningColourButton.add_theme_color_override("icon_hover_color", color)
	%RunningColourButton.add_theme_color_override("icon_pressed_color", color)
	%RunningColourButton.add_theme_color_override("icon_hover_pressed_color", color)
	Global.running_game_colour = color.to_html()
