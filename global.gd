extends Node

##REQUIRED DIRECTORIES
var base_dir : String = "res://" if OS.has_feature("editor") else OS.get_executable_path().get_base_dir() + "/"
var data_dir : String = "data/"
var library_dir : String = data_dir + "library/"
var lib_dir : String = "library/"
var games_dir : String = "games/"
var icons_dir : String = "icons/"

var default_icon_path : String = "res://system/texture/icon.svg"

var default_games_folder : String = base_dir + games_dir
var default_icons_folder : String = base_dir + icons_dir

##FILENAMES
var directories_file_name : String = "directories.csv"
var tags_file_name : String = "tags.csv"
var blacklist_file_name : String = "blacklist.csv"

var settings_file_name : String = "settings.cfg"




##SETTINGS
var library_list_mode : bool
var library_display_images : bool
var library_divider_offset : int
var library_open_to_last_selected : bool
var library_last_index : int
var library_last_game : Game
var library_preserve_scroll : bool
var library_scroll_value : float
var detail_panel_show_icon : bool
var window_preserve_mode : bool
var display_mode : int
var column_icon_size : int
var grid_icon_size : int
var detail_icon_size : int
var library_grid_text : bool
var library_font_size : int
var library_icon_filter : int
var detail_icon_filter : int
var multithread_cache_search : bool
var grid_font_size : int
var list_text_trim : int
var grid_text_trim : int
var settings_divider_offset : int

var image_cache : Array
var default_icon : ImageTexture = ImageTexture.create_from_image(load(default_icon_path)) 


func _ready() -> void:
	load_settings()

func save_settings() -> void:
	var file = ConfigFile.new()
	file.set_value("Library", "list_mode", library_list_mode)
	file.set_value("Library", "display_images", library_display_images)
	file.set_value("Library", "divider_offset", library_divider_offset)
	file.set_value("Library", "open_last_selected", library_open_to_last_selected)
	file.set_value("Library", "last_selected_index", library_last_index)
	file.set_value("Library", "preserve_scroll", library_preserve_scroll)
	file.set_value("Library", "scroll_value", library_scroll_value)
	file.set_value("Detail Panel", "show_icon", detail_panel_show_icon)
	file.set_value("Window", "preserve_mode", window_preserve_mode)
	file.set_value("Window", "display_mode", display_mode)
	file.set_value("Library", "column_icon_size", column_icon_size)
	file.set_value("Library", "grid_icon_size", grid_icon_size)
	file.set_value("Detail Panel", "detail_icon_size", detail_icon_size)
	file.set_value("Library", "grid_text", library_grid_text)
	file.set_value("Library", "font_size", library_font_size)
	file.set_value("Library", "grid_font_size", grid_font_size)
	file.set_value("Library", "icon_filter", library_icon_filter)
	file.set_value("Detail Panel", "icon_filter", detail_icon_filter)
	file.set_value("Library", "list_text_trim", list_text_trim)
	file.set_value("Library", "grid_text_trim", grid_text_trim)
	file.set_value("Window", "settings_divider_offset", settings_divider_offset)
	
	file.save(base_dir + settings_file_name)

func load_settings() -> void:
	var file = ConfigFile.new()
	var err = file.load(base_dir + settings_file_name)
	if err != OK:
		prints(base_dir + settings_file_name, "does not exist. Will be created on close. -- This is NOT an error.")
	
	library_list_mode = file.get_value("Library", "list_mode", false)
	library_display_images = file.get_value("Library", "display_images", false)
	library_divider_offset = file.get_value("Library", "divider_offset", 0)
	library_open_to_last_selected = file.get_value("Library", "open_last_selected", false)
	library_last_index = file.get_value("Library", "last_selected_index", 0)
	library_preserve_scroll = file.get_value("Library", "preserve_scroll", false)
	library_scroll_value = file.get_value("Library", "scroll_value", 0)
	detail_panel_show_icon = file.get_value("Detail Panel", "show_icon", false)
	window_preserve_mode = file.get_value("Window", "preserve_mode", false)
	display_mode = file.get_value("Window", "display_mode", 0)
	column_icon_size = file.get_value("Library", "column_icon_size", 32)
	grid_icon_size = file.get_value("Library", "grid_icon_size", 96)
	detail_icon_size = file.get_value("Detail Panel", "detail_icon_size", 32)
	library_grid_text = file.get_value("Library", "grid_text", true)
	library_font_size = file.get_value("Library", "font_size", 16)
	library_icon_filter = file.get_value("Library", "icon_filter", 0)
	detail_icon_filter = file.get_value("Detail Panel", "icon_filter", 0)
	grid_font_size = file.get_value("Library", "grid_font_size", 0)
	list_text_trim = file.get_value("Library", "list_text_trim", 0)
	grid_text_trim = file.get_value("Library", "grid_text_trim", 0)
	settings_divider_offset = file.get_value("Window", "settings_divider_offset", 0)
	
func load_csv(file_path) -> PackedStringArray:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if !file:
		print(file_path, " does not exist")
		return []
	
	if file.get_as_text() == "": return []
	
	return file.get_csv_line()

func save_to_csv(data, file_path) -> void:
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if !file:
		print(file_path, " does not exist")
	else:
		file.seek(0)
		file.store_csv_line(data)

func get_pid(proc_name : String) -> int:
	var output: Array[String]
	var command = "wmic process where name=\"%s\" get processid" % proc_name
	OS.execute("cmd.exe", ["/c", command], output)
	var pid = int(output[0].get_slice("\n",1).strip_escapes())
	return pid
