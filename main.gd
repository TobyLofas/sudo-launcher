extends Control

@onready var library = %Library
@onready var directory_manager = %DirectoryManager
@onready var edit_window = %EditWindow

func _ready() -> void:
	library.detail_panel.edit_details.connect(_on_edit_details)
	DisplayServer.window_set_min_size(Vector2i(960,540))
	create_metadata()
	directory_manager.load_directories()
	directory_manager.create_register_from_directories()
	library.build_library()
	library._on_game_list_item_selected(0)
	
func _on_register_updated() -> void:
	library.build_library()

func create_metadata() -> void:
	var base_directory = DirAccess.open(Global.base_dir)
	var file_name : String
	var _file
	
	if base_directory.dir_exists(Global.data_dir):
		print("Located /data/")
	else:
		print("NO DATA FOLDER FOUND - creating at " + Global.data_dir)
		base_directory.make_dir(Global.data_dir)
	
	if base_directory.dir_exists(Global.library_dir):
		print("Located /data/library/")
	else:
		print("NO LIBRARY FOLDER FOUND - creating at " + Global.library_dir)
		base_directory.make_dir(Global.library_dir)
	
	file_name = "directories.csv"
	if base_directory.file_exists(Global.data_dir + file_name):
		print("Located directories.csv")
	else:
		_file = FileAccess.open(Global.data_dir + file_name, FileAccess.WRITE)
	
	file_name = "tags.csv"
	if base_directory.file_exists(Global.data_dir + file_name):
		print("Located tags.csv")
	else:
		_file = FileAccess.open(Global.data_dir + file_name, FileAccess.WRITE)

func _on_edit_details() -> void:
	edit_window.game_to_edit = library.selected
	edit_window.show()
	
func _on_edit_window_details_saved() -> void:
	library.save_metadata_for_selected()
	library.detail_panel._refresh_from_data(library.selected)
	library.build_library()

func save_metadata_for_selected() -> void:
	ResourceSaver.save(library.selected, Global.library_dir + library.selected.name + ".tres")
