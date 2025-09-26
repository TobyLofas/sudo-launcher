extends Control

@onready var directory_select = $NativeFileDialog
@onready var directory_display = %DirectoryDisplay

var directories : PackedStringArray = []
var file
signal build_library(directories)
signal directory_added(directories : PackedStringArray)
signal directory_removed(directories : PackedStringArray)
signal directories_changed(directories : PackedStringArray)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func refresh_directory_display(directories) -> void:
	directory_display.clear()
	for dir in directories:
		directory_display.add_item(dir)

func _on_add_directory_pressed() -> void:
	directory_select.show()

func _on_native_file_dialog_dir_selected(dir: String) -> void:
	directories.append(dir)
	directories_changed.emit(directories)
	#file.seek(0)
	#file.store_csv_line(directory_list)
	

func _on_build_library_pressed() -> void:
	build_library.emit(directories)

func _on_directory_display_item_activated(index: int) -> void:
	OS.execute("explorer.exe", ["/select,", directories[index]])

func _on_remove_directory_pressed() -> void:
	var selected = directory_display.get_selected_items()
	if !selected:
		pass
	else:
		directories.remove_at(selected[0])
		save_directories()
	directories_changed.emit(directories)

func load_directories() -> void:
	var file = FileAccess.open(Global.base_dir + "/data/directories.csv", FileAccess.READ_WRITE)
	if !file:
		print("does not exist")
	else:
		if file.get_as_text() != "":
			var line = file.get_csv_line()
			directories = line
	file.close()
	refresh_directory_display(directories)

func save_directories() -> void:
	var file = FileAccess.open(Global.base_dir + "/data/directories.csv", FileAccess.READ_WRITE)
	if !file:
		print("does not exist")
	else:
		file.seek(0)
		file.store_csv_line(directories)
	file.close()
	refresh_directory_display(directories)
