extends Control

@onready var directory_list = %DirectoryList
@onready var directory = %Directory
@onready var directory_select = $NativeFileDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_add_directory_pressed() -> void:
	
	directory_select.show()


func _on_native_file_dialog_dir_selected(dir: String) -> void:
	directory_list.add_text(dir + "\n")
