class_name ProcessMonitor extends Node

var pid: int: set = set_pid
var active: bool = false

signal stopped(_pid)
signal started()

func _process(_delta: float) -> void:
	if not OS.is_process_running(pid): set_pid(-1)

func set_pid(new : int) -> void:
	if new == pid: return
	var old = pid
	pid = new
	if pid < 1: 
		stop(old)
		return
	if not active: start()

func stop(_pid) -> void:
	active = false
	queue_free()
	stopped.emit(_pid)

func start() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	active = true
	started.emit()

func alt_mode() -> void:
	pass
