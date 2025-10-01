extends Node

##REQUIRED DIRECTORIES
var base_dir : String = "res://" if OS.has_feature("editor") else OS.get_executable_path().get_base_dir() + "/"
var data_dir : String = "data/"
var library_dir : String = data_dir + "library/"
var games_dir : String = "games/"
var icons_dir : String = "icons/"

var default_icon_path : String = "res://system/texture/icon.svg"

##FILENAMES
var directories_file_name : String = "directories.csv"
var tags_file_name : String = "tags.csv"
var blacklist_file_name : String = "blacklist.csv"

var settings_file_name : String = "settings.cfg"

#var selected_game : Game

##SETTINGS
var library_list_mode : bool
var library_display_images : bool
var library_divider_offset : int
var library_open_to_last_selected : bool
var library_last_index : int

func save_settings() -> void:
	var file = ConfigFile.new()
	file.set_value("Library","list_mode",library_list_mode)
	file.set_value("Library", "display_images", library_display_images)
	file.set_value("Library", "divider_offset", library_divider_offset)
	file.set_value("Library", "open_last_selected", library_open_to_last_selected)
	file.set_value("Library", "last_selected_index", library_last_index)
	file.save(base_dir + settings_file_name)

func load_settings() -> void:
	var file = ConfigFile.new()
	var err = file.load(base_dir + settings_file_name)
	if err != OK:
		return
	library_list_mode = file.get_value("Library", "list_mode")
	library_display_images = file.get_value("Library", "display_images")
	library_divider_offset = file.get_value("Library", "divider_offset")
	library_open_to_last_selected = file.get_value("Library", "open_last_selected")
	library_last_index = file.get_value("Library", "last_selected_index")
