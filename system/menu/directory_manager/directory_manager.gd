extends Control

@onready var directory_select = $NativeFileDialog
@onready var directory_display = %DirectoryDisplay

var directories : PackedStringArray = []
var blacklist : PackedStringArray = []
signal directories_changed(directories : PackedStringArray)
signal metadata_updated

func refresh_directory_display(dirs) -> void:
	directory_display.clear()
	for dir in dirs:
		directory_display.add_item(dir)

func load_directories() -> void:
	directories = Global.load_csv(Global.base_dir + Global.data_dir + Global.directories_file_name)
	refresh_directory_display(directories)

func create_metadata_from_directories(dirs : PackedStringArray = directories) -> void:
	blacklist = Global.load_csv(Global.base_dir + Global.data_dir + Global.blacklist_file_name)
	for directory in dirs:
		var dir = DirAccess.open(directory)
		if !dir:
			print("An error occurred when trying to access the path: " + directory)
		else:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir():
					create_metadata_from_directories([directory + "/" + file_name])
				else:
					var extension : String = file_name.get_slice(".",1)
					var title : String = file_name.get_slice(".",0)
					if extension == "exe" or extension == "lnk":
						if not blacklist.has(file_name):
							var tgame : Game = Game.new(title, directory + "/" + file_name)
							var library_path = Global.base_dir + Global.library_dir + title
							if FileAccess.get_sha256(library_path + ".tres") == "":
								ResourceSaver.save(tgame, library_path + ".tres")
				file_name = dir.get_next()

func _on_add_directory_pressed() -> void:
	directory_select.show()

func _on_native_file_dialog_dir_selected(dir: String) -> void:
	directories.append(dir)
	directories_changed.emit(directories)

func _on_build_library_pressed() -> void:
	create_metadata_from_directories(directories)
	metadata_updated.emit()

func _on_directory_display_item_activated(index: int) -> void:
	OS.execute("explorer.exe", ["/select,", directories[index]])

func _on_remove_directory_pressed() -> void:
	var selected = directory_display.get_selected_items()
	if !selected:
		pass
	else:
		directories.remove_at(selected[0])
	directories_changed.emit(directories)

func _on_directories_changed(dirs: PackedStringArray) -> void:
	Global.save_to_csv(directories, Global.base_dir + Global.data_dir + Global.directories_file_name)
	refresh_directory_display(dirs)
