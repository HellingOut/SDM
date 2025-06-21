class_name DialogParser
extends Node

signal dialog_started
signal text_changed
signal dialog_ended

var current_line: int = 0
var output_text: String
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

func parse_line() -> void:
	if !dialog:
		return
	if current_line == 0:
		dialog_started.emit()
	if current_line >= dialog.data.size():
		dialog = null
		dialog_ended.emit()
		print("dialog ended")
		return
	
	var line = dialog.data[current_line]
	
	for key in line:
		if has_method(key):
			if line[key] is Array:
				callv(key, line[key])
			else:
				call(key, line[key])
		else:
			printerr("Method not found: ", key)
	if !line.has("say"):
		next_line()

func next_line() -> void:
	current_line += 1
	parse_line()

func print_text() -> void:
	text_changed.emit()
	print(output_text)

#region basic_funcs

# Functions for in-dialog using
func say(text: String) -> void:
	output_text = text
	call_deferred("print_text")
func set_speaker(speaker: String):
	output_text = speaker + ": " + output_text

#endregion
