# SDM
Simple Dialog Manager - JSON based dialog manager for Godot 4. Lightweight and easy to use

# Usage
Use `DialogParser` class for loading and playing dialogs (example with user interface provided). Printed text located in `output_text` property.

# Dialog example:
```json
[
  { "say": "Looks like its test timeline", "set_speaker": "Someone talks" },
  { "say": "Hello everynyan!" },
  { "function": "argument" },
  { "function2": ["argument1", 2] }
]
```

# Avaliable functions
```gdscript
## Sets new text to output text.
say(text: String) -> void
## Appends speaker_name to start of output_text
set_speaker(speaker_name: String) -> void
````
