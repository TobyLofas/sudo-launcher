extends Control

@onready var library = %Library
@onready var directory_manager = %DirectoryManager

var directories : PackedStringArray

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	directory_manager.build_library.connect(build_library)
	directory_manager.directory_added.connect(_on_directory_added)
	directory_manager.directories_changed.connect(_on_directories_changed)
	DisplayServer.window_set_min_size(Vector2i(960,540))
	
	directory_manager.load_directories()
	create_register_from_dirs(directories)
	build_library()

func build_library() -> void:
	library.load_tags()
	library.load_from_register()
	library.refresh_game_list()
	library._on_game_list_item_selected(0)

func create_register_from_dirs(directories : Array[String]) -> void:
	for directory in directories:
		var dir = DirAccess.open(directory)
		var t_dir : String = directory + "\\"
		if !dir:
			print("An error occurred when trying to access the path.")
		else:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir():
					print("Found directory: " + file_name)
				else:
					#print("Found file: " + file_name)
					var extension : String = file_name.get_slice(".",1)
					var title : String = file_name.get_slice(".",0)
					if extension == "exe" or extension == "lnk":
						var tgame : Game = Game.new(title, t_dir + file_name)
						var library_path = Global.base_dir + Global.library_dir + title
						if FileAccess.get_sha256(library_path + ".tres") == "":
							ResourceSaver.save(tgame, library_path + ".tres")
				file_name = dir.get_next()

func _on_directory_added(dir) -> void:
	directory_manager.refresh_directory_display(directories)

func _on_directories_changed(dirs) -> void:
	directory_manager.save_directories()
