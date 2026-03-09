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


func _on_detail_icon_toggled(toggled_on: bool) -> void:
	Global.detail_panel_show_icon = toggled_on


func _on_preserve_scroll_toggled(toggled_on: bool) -> void:
	Global.library_preserve_scroll = toggled_on
