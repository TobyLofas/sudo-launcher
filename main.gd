extends Control

@onready var library = %Library
@onready var directory_manager = %DirectoryManager
@onready var edit_window = %EditWindow
@onready var tag_manager = %TagManager

func _ready() -> void:
	library.detail_panel.edit_details.connect(_on_edit_details)
	
	DisplayServer.window_set_min_size(Vector2i(960,540))
	
	check_for_files()
	create_metadata()
	library.build_library()
	
func _on_metadata_updated() -> void:
	library.build_library()

func check_for_files() -> void:
	check_directory_in_directory(Global.data_dir, Global.base_dir)
	check_directory_in_directory(Global.library_dir, Global.base_dir)
	check_file_in_directory("directories.csv", Global.base_dir + Global.data_dir)
	check_file_in_directory("tags.csv", Global.base_dir + Global.data_dir)
	check_file_in_directory("blacklist.csv", Global.base_dir + Global.data_dir)

func _on_edit_details() -> void:
	edit_window.selected_game = library.selected
	edit_window.show()
	
func _on_edit_window_details_saved() -> void:
	library.save_metadata_for_selected()
	library.detail_panel._refresh_from_data(library.selected)

func check_directory_in_directory(dir, base_dir) -> void:
	var base_directory = DirAccess.open(base_dir)
	if !base_directory.dir_exists(dir):
		base_directory.make_dir(dir)

func check_file_in_directory(file_name, directory) -> void:
	var base_directory = DirAccess.open(directory)
	var file
	if !base_directory.file_exists(file_name):
		file = FileAccess.open(Global.data_dir + file_name, FileAccess.WRITE)

func create_metadata() -> void:
	library.load_tags(tag_manager.tags)
	directory_manager.load_directories()
	directory_manager.create_metadata_from_directories()
	
