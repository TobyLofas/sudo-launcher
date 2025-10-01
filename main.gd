extends Control

@onready var library = %Library
@onready var directory_manager = %DirectoryManager
@onready var edit_window = %EditWindow
@onready var tag_manager = %TagManager

func _ready() -> void:
	library.detail_panel.edit_details.connect(_on_edit_details)
	library.detail_panel.add_to_blacklist.connect(remove_game)
	DisplayServer.window_set_min_size(Vector2i(960,540))
	check_for_files()
	create_metadata()
	library.build_library()
	
	
func _on_metadata_updated() -> void:
	library.build_library()

func check_for_files() -> void:
	check_directory_in_directory(Global.library_dir, Global.base_dir)
	check_directory_in_directory(Global.data_dir, Global.base_dir)
	check_directory_in_directory(Global.games_dir, Global.base_dir)
	check_directory_in_directory(Global.icons_dir, Global.base_dir)
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
	if !base_directory.file_exists(file_name):
		var _file = FileAccess.open(Global.data_dir + file_name, FileAccess.WRITE)

func create_metadata() -> void:
	library.load_tags(tag_manager.tags)
	directory_manager.load_directories()
	directory_manager.create_metadata_from_directories()

func _on_tag_manager_close_requested() -> void:
	edit_window.load_details()

func _on_edit_window_close_requested() -> void:
	library.refresh_game_list()

func remove_game() -> void:
	var file_name = library.selected.path.get_slice("/", library.selected.path.get_slice_count("/")-1)
	var _name : String = file_name.get_slice(".",0)
	var _dir = DirAccess.remove_absolute(Global.base_dir+Global.library_dir+_name+".tres")
	directory_manager.blacklist.append(file_name)
	#save_blacklist()
	Global.save_to_csv(directory_manager.blacklist, Global.base_dir + Global.data_dir + Global.blacklist_file_name)
	library.build_library()

func save_blacklist() -> void:
	var file = FileAccess.open(Global.base_dir + Global.data_dir + "blacklist.csv", FileAccess.WRITE)
	if !file:
		print("blacklist.csv does not exist")
	else:
		file.seek(0)
		file.store_csv_line(directory_manager.blacklist)
		print(directory_manager.blacklist)


func _on_tree_exiting() -> void:
	Global.save_settings()
