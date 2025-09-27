extends Control

var available_tags : PackedStringArray = ["ttag1", "ttag2"]
var filtered_available_tags : PackedStringArray
var selected_tags : PackedStringArray

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ApplyTags.pressed.connect(_on_apply_tags)
	%RemoveTags.pressed.connect(_on_remove_tags)
	%AvailableTagsDisplay.item_activated.connect(_on_apply_tags)
	%SelectedTagsDisplay.item_activated.connect(_on_remove_tags)
	refresh_tag_displays()

func refresh_tag_displays() -> void:
	filter_available_tags()
	%AvailableTagsDisplay.clear()
	for tag in filtered_available_tags:
		%AvailableTagsDisplay.add_item(tag)
		
	%SelectedTagsDisplay.clear()
	for tag in selected_tags:
		%SelectedTagsDisplay.add_item(tag)

func load_tags() -> void:
	var file = FileAccess.open(Global.base_dir + "/data/tags.csv", FileAccess.READ_WRITE)
	if !file:
		print("does not exist")
	else:
		if file.get_as_text() != "":
			var line = file.get_csv_line()
			available_tags = line
	refresh_tag_displays()

func save_tags() -> void:
	var file = FileAccess.open(Global.base_dir + "/data/directories.csv", FileAccess.READ_WRITE)
	if !file:
		print("does not exist")
	else:
		file.seek(0)
		file.store_csv_line(available_tags)
	refresh_tag_displays()

func _on_apply_tags(selected = %AvailableTagsDisplay.get_selected_items()) -> void:
	for index in len(selected):
		if not selected_tags.has(filtered_available_tags[selected[index]]):
			selected_tags.append(filtered_available_tags[selected[index]])
	refresh_tag_displays()

func _on_remove_tags(selected = %SelectedTagsDisplay.get_selected_items()) -> void:
	selected.reverse()
	for index in len(selected):
		selected_tags.remove_at(selected[index])
	refresh_tag_displays()

func filter_available_tags() -> void:
	filtered_available_tags.clear()
	for tag in available_tags:
		if not selected_tags.has(tag):
			filtered_available_tags.append(tag)
