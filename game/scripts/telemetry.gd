class_name OrionTelemetry
extends RefCounted
## Local, opt-in JSONL. No network, user identifiers or keyboard logging.
var enabled := false
var run_id := ""
var elapsed := 0.0
var write_failed := false
const LOG_PATH := "user://playtest.jsonl"

func begin(oath: String) -> void:
	elapsed = 0.0
	run_id = str(Time.get_ticks_usec())
	record("run_started", {"oath": oath, "build_version": "0.1.0", "seed": "handcrafted_arena"})

func record(event: String, payload: Dictionary = {}) -> void:
	if not enabled:
		return
	var mode := FileAccess.READ_WRITE if FileAccess.file_exists(LOG_PATH) else FileAccess.WRITE
	var file := FileAccess.open(LOG_PATH, mode)
	if file == null:
		write_failed = true
		return
	file.seek_end()
	file.store_line(JSON.stringify({"event": event, "run_id": run_id, "elapsed": snappedf(elapsed, 0.01), "payload": payload}))
	file.close()
