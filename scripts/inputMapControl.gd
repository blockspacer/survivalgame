extends Node

# Axis is float
# Button is bool

func _input(event):
    print(event.as_text())

# Called when the node enters the scene tree for the first time.
func _ready():
	
	InputMap.add_action("button_accept")
	InputMap.action_add_event("button_accept",InputEvent(
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
