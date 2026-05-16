extends Window

var selected_game : Game

signal details_saved
signal icon_updated

func _on_icon_path_button_pressed() -> void:
	%IconFileDialog.add_filter("*.svg, *.png, *.jpg, *.jpeg", "Image (.svg, .png, .jpg, .jpeg)")
	%IconFileDialog.show()

func _on_exe_path_button_pressed() -> void:
	%ExeFileDialog.add_filter("*.exe, *.lnk", "Executable (.exe, .lnk)")
	%ExeFileDialog.show()

func _on_icon_path_dialog_file_selected(path: String) -> void:
	%IconPathDisplay.text = path
	selected_game.icon = path
	icon_updated.emit()

func _on_exe_path_dialog_file_selected(path: String) -> void:
	%ExePathDisplay.text = path
	selected_game.path = path

func _on_exe_file_dialog_file_selected(path: String) -> void:
	%ExePathDisplay.text = path
	selected_game.path = path


func _on_icon_file_dialog_file_selected(path: String) -> void:
	%IconPathDisplay.text = path
	selected_game.icon = path
	icon_updated.emit()

func _on_close_requested() -> void:
	save_details()
	hide()

func _on_visibility_changed() -> void:
	load_details()

func load_details() -> void:
	if not selected_game: return
	%TitleEdit.text = selected_game.name
	%ExePathDisplay.text = selected_game.path
	%IconPathDisplay.text = selected_game.icon
	%YearEdit.text = str(selected_game.year)
	%DeveloperEdit.text = selected_game.developer
	%LaunchArguments.text = selected_game.args
	%AltLaunch.button_pressed = selected_game.alternative_launch_mode
	load_tags()

func save_details() -> void:
	if not selected_game: return
	selected_game.name = %TitleEdit.text
	selected_game.path = %ExePathDisplay.text
	selected_game.icon = %IconPathDisplay.text
	selected_game.year = int(%YearEdit.text)
	selected_game.developer = %DeveloperEdit.text 
	selected_game.args = %LaunchArguments.text
	details_saved.emit()

func _on_save_button_pressed() -> void:
	save_details()

func _on_add_tag_button_pressed() -> void:
	%TagManager.selected_game = selected_game
	%TagManager.show()

func _on_icon_reset_button_pressed() -> void:
	selected_game.icon = Global.default_icon_path
	%IconPathDisplay.text = Global.default_icon_path
	details_saved.emit()

func load_tags() -> void:
	if not selected_game: return
	%TagDisplayList.clear()
	for tag in selected_game.tags:
		%TagDisplayList.add_item(tag)


func _on_check_button_toggled(toggled_on: bool) -> void:
	selected_game.alternative_launch_mode = toggled_on
