extends Control

func _ready() -> void:
	%VersionLabel.text = ProjectSettings.get_setting("application/config/version")
	

func _on_list_mode_toggled(toggled_on: bool) -> void:
	Global.library_list_mode = toggled_on
	Global.save_settings()

func _on_open_to_last_toggled(toggled_on: bool) -> void:
	Global.library_open_to_last_selected = toggled_on
	Global.save_settings()

func _on_show_icons_toggled(toggled_on: bool) -> void:
	Global.library_display_images = toggled_on
	Global.save_settings()

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

func _on_detail_icon_toggled(toggled_on: bool) -> void:
	Global.detail_panel_show_icon = toggled_on


func _on_preserve_scroll_toggled(toggled_on: bool) -> void:
	Global.library_preserve_scroll = toggled_on


func _on_check_box_toggled(toggled_on: bool) -> void:
	%Advanced.visible = toggled_on
	%AdvancedSeperator.visible = toggled_on


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


func _on_multi_search_toggled(toggled_on: bool) -> void:
	Global.multithread_cache_search = toggled_on
