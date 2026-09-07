class_name ProcessManager extends Node

const COMMANDS_PER_SECOND : int = 10

var _monitor_pid : int
var _process_io : FileAccess

var _target_pid : int = 0

var _timer : Timer

signal started(pid)
signal stopped(pid)

func _ready() -> void:
	_timer = Timer.new()
	_timer.wait_time = 1.0/clampi(COMMANDS_PER_SECOND,1,20)
	_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	_timer.timeout.connect(_send_command)
	add_child(_timer)
	add_to_group(&"monitors")

func _process(_delta: float) -> void:
	var result = _process_io.get_line()
	if not result: return
	if result.is_valid_int():
		if int(result) == 0:
			_timer.stop()
			process_mode = Node.PROCESS_MODE_DISABLED
			OS.kill(_monitor_pid)
			stopped.emit(_target_pid)
			_target_pid = 0
			queue_free()

func start_process(path: String = "") -> void:
	if not path: return
	if process_mode == ProcessMode.PROCESS_MODE_ALWAYS: return
	var _target_name : String = get_process_name_from_path(path)
	var _pre_pids : Array = get_pids_by_name(_target_name) ##Get pids for the program name before starting the program
	OS.execute("cmd",["/c", "start", "/b", "/d", path.get_base_dir(), path.get_file()]) ##then start the program
	var _post_pids : Array = get_pids_by_name(_target_name) ##then get the pids again
	_target_pid = int(_post_pids.front())
	if _pre_pids: ##If there were any pids before starting the program (e.g. there was already an instance running) 
		 ##then get the difference between the pre and post pids to find the pid of the program that has just launched
		_target_pid = int(_post_pids.filter(func(x): return not _pre_pids.has(x)).front())
	_create_monitor() ## Launch powershell program monitor
	_timer.start()
	process_mode = Node.PROCESS_MODE_ALWAYS
	started.emit(_target_pid)

func _send_command() -> void:
	if _target_pid == 0: return
	var command = "get-process -Id %s | measure-object -Line | select Lines -expandproperty Lines\n" % _target_pid 
	_process_io.store_string(command)

func _create_monitor() -> void:
	var monitor = OS.execute_with_pipe('powershell.exe', ["-NoLogo"], false)
	_monitor_pid = monitor["pid"]
	_process_io = monitor.get("stdio", null) as FileAccess

static func get_pids_by_name(file_name: String) -> PackedStringArray:
	var _command = "get-process %s -erroraction SilentlyContinue | select-object Id -expandproperty Id\n" % file_name.get_file()
	var _output : Array[String] = []
	OS.execute("powershell.exe", ["-Command", _command], _output)
	var _stripped_output : PackedStringArray = _output.front().remove_chars("\r").split("\n", false)
	return _stripped_output

static func get_process_name_from_path(path: String) -> String:
	if path.get_extension() == "lnk": ## EXTRACT EXE PATH FROM SHORTCUT
		var command : String = "type "+"\""+path.replace_char(47,92)+"\""+"|find \".exe\"" ##open shortcut as text file and search ".exe"
		var output : Array[String]
		OS.execute("cmd.exe", ["/c", command], output) ## 2 outputs: 0. the exe name 1. the full filepath to the exe
		path = output.front().get_slice("\n",1).strip_escapes() ##get second output and strip escapes
	return path.get_file().split(".")[0].to_lower()
