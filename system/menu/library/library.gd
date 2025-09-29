extends Control

@onready var game_list = %GameList
@onready var detail_panel = %DetailPanel
@onready var top_bar = %TopBar

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
	top_bar.image_toggle.toggled.connect(toggle_images)
	
	top_bar.sort_changed.connect(refresh_game_list)
	
	detail_panel.play_button.pressed.connect(start_game)
	game_list.item_activated.connect(start_game)

func _on_game_list_item_selected(index: int) -> void:
	if filtered_library.size() != 0:
		selected = filtered_library[index]
	detail_panel._refresh_from_data(selected)
	#Global.selected_game = selected

func filter_by_search(term : String) -> void:
	_search_filtered = []
	for item in library:
		if item.name.containsn(term):
			_search_filtered.append(item)
	refresh_game_list()

func filter_by_tag(filter_tags : PackedStringArray) -> void:
	_tag_filtered = []
	filter_tags.sort()
	for item in library:
		item.tags.sort()
		if filter_tags == item.tags:
			for tag in filter_tags:
				_tag_filtered.append(item)
		elif filter_tags.size() < item.tags.size():
			for tag in filter_tags:
				if item.tags.has(tag):
					_tag_filtered.append(item)
	refresh_game_list()

func refresh_game_list() -> void:
	_apply_filters()
	_apply_ordering()
	create_game_list_from_filtered_library()

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
	if top_bar.invert_sort:
		filtered_library.reverse()

func create_game_list_from_filtered_library() -> void:
	game_list.clear()
	for item in filtered_library:
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

func toggle_images(state: bool) -> void:
	for index in game_list.item_count:
		if state:
			game_list.set_item_icon(index, null)
		else:
			var icon
			if library[index].icon.contains("res://"):
				icon = load(library[index].icon)
			else:
				var image
				var image_path = library[index].icon
				image = Image.new()
				image.load(image_path)
				icon = ImageTexture.new()
				icon.set_image(image)
			game_list.set_item_icon(index, icon)

func create_library_from_metadata(directory : String) -> void:
	library.clear()
	var dir = DirAccess.open(directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				#print("Found file: " + file_name)
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
	refresh_game_list()
	game_list.select(0)
	_on_game_list_item_selected(0)

func save_metadata_for_selected() -> void:
	ResourceSaver.save(selected, Global.library_dir + selected.name + ".tres")

func _on_tag_manager_tags_updated(_tags: Variant) -> void:
	top_bar.load_tags(_tags)

func _sort_by_name(a : Game, b : Game):
	if a.name < b.name:
		return true
	return false
	
func _sort_by_year(a : Game, b : Game):
	if a.year < b.year:
		return true
	return false
