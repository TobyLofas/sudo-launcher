extends Node

var pid: int: set = set_pid
var pids: PackedInt32Array
var active: bool = false

signal pid_changed()
signal pid_added()
signal pid_removed()
signal stopped()
signal started()

func _process(_delta: float) -> void:
	if not OS.is_process_running(pid): set_pid(-1)

func _on_pid_changed() -> void:
	if pid < 0: 
		stop()
		return
	if not active: start()

func set_pid(new : int) -> void:
	if new == pid: return
	pid = new
	pid_changed.emit()

func stop() -> void:
	active = false
	process_mode = Node.PROCESS_MODE_DISABLED
	stopped.emit()
	
func start() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	active = true
	started.emit()

func track_pid(new_pid: int) -> void:
	pids.append(new_pid)

func add_pid(new_pid) -> void:
	if pids.has(new_pid): return
	
	pids.append(new_pid)
	pid_added.emit()

func remove_pid() -> void:
	pass
