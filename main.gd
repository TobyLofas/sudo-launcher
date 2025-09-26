extends Control

@onready var library = %Library
@onready var settings = %Settings

var directories : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings.build_library.connect(build_library)
	DisplayServer.window_set_min_size(Vector2i(960,540))
	
	load_directories()
	create_register_from_dirs(directories)
	build_library(directories)
	
func load_directories() -> void:
	var data = load(Global.base_dir + Global.data_dir + "directories.csv")
	if data: directories = data.records ##ADD SYSTEM TO CREATE TAGS.CSV IF NONE EXISTS

func build_library(directories : Array[String]) -> void:
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
