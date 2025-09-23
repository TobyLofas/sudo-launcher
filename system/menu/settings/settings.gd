extends Control

@onready var directory_list = %DirectoryList
@onready var directory_select = $NativeFileDialog

var dir_list : Array[String] = []
signal build_library(directories)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_add_directory_pressed() -> void:
	directory_select.show()


func _on_native_file_dialog_dir_selected(dir: String) -> void:
	dir_list.append(dir)
	directory_list.text = ""
	for d in dir_list:
		directory_list.add_text(d + "\n")


func _on_build_library_pressed() -> void:
	build_library.emit(dir_list)
