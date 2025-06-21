extends Control

@onready var label: Label = $Panel/Label
@onready var debug_info: Label = $DebugInfo
@onready var letter_timer: Timer = $Panel/Label/LetterTimer
@onready var dialog_parser: DialogParser = $DialogParser

func _ready() -> void:
	modulate.a = 0
	hide()
	dialog_parser.dialog_started.connect(_on_dialog_started)
	dialog_parser.text_changed.connect(set_text)
	dialog_parser.dialog_ended.connect(_on_dialog_ended)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("next_line"):
		if label.visible_characters <= label.text.length() and label.visible_characters != -1:
			label.visible_characters = -1
			letter_timer.stop()
		else:
			letter_timer.start()
			dialog_parser.next_line()

func _process(_delta: float) -> void:
	debug_info.text = \
		"Visible characters: " + str(label.visible_characters)

func set_text():
	label.visible_characters = 0
	label.text = dialog_parser.output_text

#region animation

func _on_dialog_started():
	show()
	letter_timer.start()
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate:a", 1, 0.2)
	
func _on_dialog_ended():
	letter_timer.stop()
	label.text = ""
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0, 0.2)
	tween.finished.connect(_on_hiding_ended)
	
func _on_hiding_ended():
	hide()

#endregion
