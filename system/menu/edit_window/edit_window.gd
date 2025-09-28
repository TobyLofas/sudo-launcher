extends Window

var selected_game : Game

signal details_saved

func _on_icon_path_button_pressed() -> void:
	%IconPathDialog.add_filter("*.svg, *.png, *.jpg, *.jpeg", "Image (.svg, .png, .jpg, .jpeg)")
	%IconPathDialog.show()

func _on_exe_path_button_pressed() -> void:
	%ExePathDialog.add_filter("*.exe, *.lnk", "Executable (.exe, .lnk)")
	%ExePathDialog.show()

func _on_icon_path_dialog_file_selected(path: String) -> void:
	%IconPathDisplay.text = path
	selected_game.icon = path

func _on_exe_path_dialog_file_selected(path: String) -> void:
	%ExePathDisplay.text = path
	selected_game.path = path

func _on_close_requested() -> void:
	save_details()
	hide()

func _on_visibility_changed() -> void:
	load_details()

func load_details() -> void:
	%TitleEdit.text = selected_game.name
	%ExePathDisplay.text = selected_game.path
	%IconPathDisplay.text = selected_game.icon
	%YearEdit.text = str(selected_game.year)
	%DeveloperEdit.text = selected_game.developer
	%LaunchArguments.text = selected_game.args
	for tag in selected_game.tags:
		%TagDisplayList.add_item(tag)

func save_details() -> void:
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
	

	
