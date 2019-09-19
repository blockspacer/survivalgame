extends TextureRect

export(NodePath) var skypath;
onready var skytexture = get_node(skypath)

# Called when the node enters the scene tree for the first time.
func _ready():
	print(skytexture)
	if skytexture:
		texture = skytexture.get_viewport().get_texture()
		print(texture)

# warning-ignore:unused_argument
#func _process(delta):
#	pass
	
