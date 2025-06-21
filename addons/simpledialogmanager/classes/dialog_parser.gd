class_name DialogParser
extends Node

signal dialog_started
signal text_changed
signal dialog_ended

var current_line: int = 0
var output_text: String:
	set(new_text):
		output_text = new_text
		text_changed.emit()
		

var dialog: JSON:
	set(new_value):
		if new_value:
			assert(new_value.data is Array, "JSON should be array")
		dialog = new_value

func start_dialog(new_dialog: JSON = null):
	if new_dialog:
		dialog = new_dialog
	current_line = 0
	parse_line()

func next_line() -> void:
	current_line += 1
	parse_line()

func parse_line() -> void:
	var should_stop: bool = false
	if !dialog:
		return
	if current_line == 0:
		print(dialog, " started")
		dialog_started.emit()
	while !should_stop:
		if current_line >= dialog.data.size():
			print(dialog, " ended")
			dialog = null
			dialog_ended.emit()
			return
		var line = dialog.data[current_line]
		should_stop = _should_line_stop(line)
		for key in line:
			if has_method(key):
				if line[key] is Array: callv(key, line[key])
				else: call(key, line[key])
			else:
				printerr("Method not found: ", key)
		if !should_stop:
			current_line += 1
		else:
			return

func _should_line_stop(line: Dictionary) -> bool:
	var result: bool = false
	if line.has("say"):
		result = true
	return result

#region basic_funcs

# Functions for in-dialog using
func say(text: String) -> void:
	output_text = text
	
func set_speaker(speaker: String):
	output_text = speaker + ": " + output_text

#endregion
