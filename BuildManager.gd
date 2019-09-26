extends Spatial

onready var woodplank = preload("res://building/plank.tscn")

func _ready():
	pass # Replace with function body.

func _input(event):
	pass

func _process(delta):
	if Input.is_action_just_pressed():
		self.add_child(scene.instance())
