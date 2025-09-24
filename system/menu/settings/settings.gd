extends Control

@onready var directory_select = $NativeFileDialog
@onready var directory_display = %DirectoryDisplay

var directory_list : PackedStringArray = []
var file
signal build_library(directories)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	file = FileAccess.open(Global.base_dir + "/data/directories.csv", FileAccess.READ_WRITE)
	if !file:
		print("does not exist")
	else:
		if file.get_as_text() != "":
			var line = file.get_csv_line()
			directory_list = line
	refresh_directory_display()


func _on_add_directory_pressed() -> void:
	directory_select.show()

func _on_native_file_dialog_dir_selected(dir: String) -> void:
	directory_list.append(dir)
	file.seek(0)
	file.store_csv_line(directory_list)
	refresh_directory_display()

func _on_build_library_pressed() -> void:
	build_library.emit(directory_list)

func refresh_directory_display() -> void:
	directory_display.clear()
	for dir in directory_list:
		directory_display.add_item(dir)
	print(directory_list)

func _on_directory_display_item_activated(index: int) -> void:
	OS.execute("explorer.exe", ["/select,", directory_list[index]])



func _on_remove_directory_pressed() -> void:
	var selected = directory_display.get_selected_items()
	if !selected:
		pass
	else:
		directory_list.remove_at(selected[0])
		file.seek(0)
		file.store_csv_line(directory_list)
	refresh_directory_display()
