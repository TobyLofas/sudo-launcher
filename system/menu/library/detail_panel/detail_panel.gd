extends Control

@onready var name_display = %Name
@onready var year_display = %Year
@onready var developer_display = %Developer
@onready var tags_list = %TagsList
@onready var file_path = %FilePath

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _refresh_from_data(selected : Game) -> void:
	name_display.text = selected.name
	year_display.text = str(selected.year)
	developer_display.text = selected.developer
	tags_list.clear()
	for tag in selected.tags:
		tags_list.add_item(tag)
	file_path.set_text("[i]" + selected.path)
