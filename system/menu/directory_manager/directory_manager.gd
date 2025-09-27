extends Control

@onready var directory_select = $NativeFileDialog
@onready var directory_display = %DirectoryDisplay

var directories : PackedStringArray = []

signal build_library(directories)
signal directories_changed(directories : PackedStringArray)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_directories()
	create_register_from_directories(directories)

func refresh_directory_display(dirs) -> void:
	directory_display.clear()
	for dir in dirs:
		directory_display.add_item(dir)

func _on_add_directory_pressed() -> void:
	directory_select.show()

func _on_native_file_dialog_dir_selected(dir: String) -> void:
	directories.append(dir)
	directories_changed.emit(directories)

func _on_build_library_pressed() -> void:
	build_library.emit(directories)
	create_register_from_directories(directories)

func _on_directory_display_item_activated(index: int) -> void:
	OS.execute("explorer.exe", ["/select,", directories[index]])

func _on_remove_directory_pressed() -> void:
	var selected = directory_display.get_selected_items()
	if !selected:
		pass
	else:
		directories.remove_at(selected[0])
	directories_changed.emit(directories)

func load_directories() -> void:
	var file = FileAccess.open(Global.base_dir + "/data/directories.csv", FileAccess.READ_WRITE)
	if !file:
		print("does not exist")
	else:
		if file.get_as_text() != "":
			var line = file.get_csv_line()
			directories = line
	refresh_directory_display(directories)

func save_directories() -> void:
	var file = FileAccess.open(Global.base_dir + "/data/directories.csv", FileAccess.READ_WRITE)
	if !file:
		print("does not exist")
	else:
		file.seek(0)
		file.store_csv_line(directories)
	refresh_directory_display(directories)

func create_register_from_directories(dirs : Array[String]) -> void:
	for directory in dirs:
		var dir = DirAccess.open(directory)
		var t_dir : String = directory + "/"
		if !dir:
			print("An error occurred when trying to access the path.")
		else:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir():
					print("Found directory: " + file_name)
				else:
					print("Found file: " + file_name)
					var extension : String = file_name.get_slice(".",1)
					var title : String = file_name.get_slice(".",0)
					if extension == "exe" or extension == "lnk":
						var tgame : Game = Game.new(title, t_dir + file_name)
						var library_path = Global.base_dir + Global.library_dir + title
						if FileAccess.get_sha256(library_path + ".tres") == "":
							ResourceSaver.save(tgame, library_path + ".tres")
				file_name = dir.get_next()

func _on_directories_changed(dirs: PackedStringArray) -> void:
	save_directories()
	refresh_directory_display(dirs)
	
