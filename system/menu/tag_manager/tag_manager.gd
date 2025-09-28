extends Window

var tags : PackedStringArray
var filtered_tags : PackedStringArray
var selected_tags : PackedStringArray

var selected_game : Game

signal tags_updated(tags)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ApplyTags.pressed.connect(_on_apply_tags)
	%RemoveTags.pressed.connect(_on_remove_tags)
	%AvailableTagsDisplay.item_activated.connect(_on_apply_tags)
	%SelectedTagsDisplay.item_activated.connect(_on_remove_tags)
	load_tags()
	refresh_tag_displays()

func refresh_tag_displays() -> void:
	filter_available_tags()
	%AvailableTagsDisplay.clear()
	for tag in filtered_tags:
		%AvailableTagsDisplay.add_item(tag)
		
	%SelectedTagsDisplay.clear()
	for tag in selected_tags:
		%SelectedTagsDisplay.add_item(tag)

func load_tags() -> void:
	var file = FileAccess.open(Global.base_dir + "/data/tags.csv", FileAccess.READ)
	if !file:
		print("tags.csv does not exist")
	else:
		if file.get_as_text() != "":
			tags.clear()
			var line = file.get_csv_line()
			tags = line
	refresh_tag_displays()

func save_tags() -> void:
	var file = FileAccess.open(Global.base_dir + "/data/tags.csv", FileAccess.WRITE)
	if !file:
		print("tags.csv does not exist")
	else:
		file.seek(0)
		file.store_csv_line(tags)
	refresh_tag_displays()

func _on_apply_tags(selected = %AvailableTagsDisplay.get_selected_items()) -> void:
	for index in len(selected):
		if not selected_tags.has(filtered_tags[selected[index]]):
			selected_tags.append(filtered_tags[selected[index]])
	selected_game.tags = selected_tags
	refresh_tag_displays()

func _on_remove_tags(selected = %SelectedTagsDisplay.get_selected_items()) -> void:
	selected.reverse()
	for index in len(selected):
		selected_tags.remove_at(selected[index])
	refresh_tag_displays()

func filter_available_tags() -> void:
	filtered_tags.clear()
	for tag in tags:
		if not selected_tags.has(tag):
			filtered_tags.append(tag)

func _on_add_tag_pressed() -> void:
	if %TagName.text != "":
		tags.append(%TagName.text)
		%TagName.clear()
	save_tags()
	tags_updated.emit(tags)

func _on_close_requested() -> void:
	hide()


func _on_delete_tag_pressed() -> void:
	var tags_to_delete = %AvailableTagsDisplay.get_selected_items()
	tags_to_delete.reverse()
	for index in len(tags_to_delete):
		tags.remove_at(tags_to_delete[index])
	save_tags()
	refresh_tag_displays()


func _on_visibility_changed() -> void:
	selected_tags = selected_game.tags
	refresh_tag_displays()
