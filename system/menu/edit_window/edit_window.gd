extends Window

var game_to_edit : Game

signal details_saved

func _on_icon_path_button_pressed() -> void:
	%IconPathDialog.add_filter("*.svg, *.png, *.jpg, *.jpeg", "Image (.svg, .png, .jpg, .jpeg)")
	%IconPathDialog.show()

func _on_exe_path_button_pressed() -> void:
	%ExePathDialog.add_filter("*.exe, *.lnk", "Executable (.exe, .lnk)")
	%ExePathDialog.show()

func _on_icon_path_dialog_file_selected(path: String) -> void:
	%IconPathDisplay.text = path
	game_to_edit.icon = path

func _on_exe_path_dialog_file_selected(path: String) -> void:
	%ExePathDisplay.text = path
	game_to_edit.path = path

func _on_close_requested() -> void:
	hide()

func _on_visibility_changed() -> void:
	load_details()

func load_details() -> void:
	%TitleEdit.text = game_to_edit.name
	%ExePathDisplay.text = game_to_edit.path
	%IconPathDisplay.text = game_to_edit.icon
	%YearEdit.text = str(game_to_edit.year)
	%DeveloperEdit.text = game_to_edit.developer

func save_details() -> void:
	game_to_edit.name = %TitleEdit.text
	game_to_edit.path = %ExePathDisplay.text
	game_to_edit.icon = %IconPathDisplay.text
	game_to_edit.year = int(%YearEdit.text)
	game_to_edit.developer = %DeveloperEdit.text 


func _on_save_button_pressed() -> void:
	save_details()
	details_saved.emit()
