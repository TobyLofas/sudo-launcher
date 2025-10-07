extends Control

@onready var game_list = %GameList
@onready var detail_panel = %DetailPanel
@onready var top_bar = %TopBar
@onready var divider = %Divider

var library : Array[Game]
var filtered_library : Array[Game]
var display_library : Array[Game]
var selected : Game

var tags : Array
var directories : Array

var _search_filtered : Array[Game]
var _tag_filtered : Array[Game]

func _ready() -> void:
	top_bar.search_bar.text_changed.connect(filter_by_search)
	top_bar.tags_changed.connect(filter_by_tag)
	top_bar.image_toggle.pressed.connect(refresh_game_list)
	top_bar.list_mode_toggle.pressed.connect(refresh_game_list)
	top_bar.sort_changed.connect(refresh_game_list)
	detail_panel.play_button.pressed.connect(start_game)
	game_list.item_activated.connect(start_game)
	
	divider.split_offset = Global.library_divider_offset
	

func _on_game_list_item_selected(index: int) -> void:
	if filtered_library.size() != 0:
		selected = filtered_library[index]
	detail_panel._refresh_from_data(selected)
	Global.library_last_index = library.find(selected)
	Global.library_last_game = selected
	

func filter_by_search(term : String) -> void:
	_search_filtered = []
	for item in library:
		if item.name.containsn(term):
			_search_filtered.append(item)
	refresh_game_list(true)

func filter_by_tag(filter_tags : PackedStringArray) -> void:
	_tag_filtered = []
	filter_tags.sort()
	for item in library:
		item.tags.sort()
		if filter_tags == item.tags:
			_tag_filtered.append(item)
		elif filter_tags.size() < item.tags.size():
			for tag in filter_tags:
				if item.tags.has(tag):
					_tag_filtered.append(item)
	refresh_game_list(true)

func refresh_game_list(keep_selected : bool = true) -> void:
	_apply_filters()
	_apply_ordering()
	create_game_list_from_filtered_library()
	if game_list.item_count > 0 and keep_selected and game_list.item_count > Global.library_last_index:
		var selected_index = filtered_library.find(library[Global.library_last_index])
		if selected_index > 0:
			game_list.select(selected_index)
			_on_game_list_item_selected(selected_index)
			return
	if game_list.item_count > 0: game_list.select(0)
	_on_game_list_item_selected(0)

func _apply_filters() -> void:
	filtered_library = []
	if top_bar.search_bar.text != "" and !top_bar.selected_tags.is_empty():
		for s_item in _search_filtered:
			for t_item in _tag_filtered:
				if t_item == s_item:
					filtered_library.append(t_item)
	elif top_bar.search_bar.text != "":
		for s_item in _search_filtered:
			filtered_library.append(s_item)
	elif !top_bar.selected_tags.is_empty():
		for t_item in _tag_filtered:
			filtered_library.append(t_item)
	else:
		filtered_library = library

func _apply_ordering() -> void:
	var sort_type = top_bar.sort_type.get_item_text(top_bar.sort_type.get_selected_id())
	if sort_type == "Name":
		filtered_library.sort_custom(_sort_by_name)
	elif sort_type == "Date":
		filtered_library.sort_custom(_sort_by_year)
	elif sort_type == "Path":
		filtered_library.sort_custom(_sort_by_path)
	if top_bar.invert_sort:
		filtered_library.reverse()

func create_game_list_from_filtered_library() -> void:
	game_list.clear()
	for item in filtered_library:
		if not Global.library_display_images:
			game_list.add_item(item.name, null)
		else: 
			var icon
			if item.icon.contains("res://"):
				icon = load(item.icon)
			else:
				var image
				var image_path = item.icon
				image = Image.new()
				image.load(image_path)
				icon = ImageTexture.new()
				icon.set_image(image)
			game_list.add_item(item.name, icon)
	if Global.library_list_mode:
		game_list.max_columns = 1
		game_list.icon_mode = game_list.ICON_MODE_LEFT
		game_list.fixed_icon_size = Vector2i(32,32)
	else:
		game_list.max_columns = 15
		game_list.icon_mode = game_list.ICON_MODE_TOP
		game_list.fixed_icon_size = Vector2i(64,64)
	

func create_library_from_metadata(directory : String) -> void:
	library.clear()
	var dir = DirAccess.open(directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				var extension : String = file_name.get_slice(".",1)
				if extension == "tres":
					var game : Game = load(directory + file_name) as Game
					library.append(game)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func start_game(_id: int = 0) -> void:
	OS.create_process("cmd.exe", ["/c", selected.path, selected.args])

func load_tags(_tags : Array[String]) -> void:
	tags = _tags
	top_bar.load_tags(_tags)

func build_library() -> void:
	create_library_from_metadata(Global.base_dir + Global.library_dir)
	Global.library_last_game = library[Global.library_last_index]
	refresh_game_list(Global.library_open_to_last_selected)

func save_metadata_for_selected() -> void:
	var file_name = selected.path.get_slice("/", selected.path.get_slice_count("/")-1)
	var _name : String = file_name.get_slice(".",0)
	ResourceSaver.save(selected, Global.base_dir+Global.library_dir+_name+".tres")

func _on_tag_manager_tags_updated(_tags: Variant) -> void:
	top_bar.load_tags(_tags)

func _sort_by_name(a : Game, b : Game):
	if a.name < b.name:
		return true
	return false

func _sort_by_year(a : Game, b : Game):
	if a.year < b.year:
		return true
	if a.year == b.year:
		return _sort_by_name(a, b)
	return false

func _sort_by_path(a : Game, b : Game):
	if a.path < b.path:
		return true
	return false

func _on_divider_dragged(offset: int) -> void:
	Global.library_divider_offset = offset

func _on_visibility_changed() -> void:
	if top_bar:
		refresh_game_list(true)
