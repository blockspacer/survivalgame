extends TextureRect

export(NodePath) var cloudpath;
onready var cloudtexture = get_node(cloudpath)

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(cloudtexture)
	if cloudtexture:
		texture = cloudtexture.get_viewport().get_texture()
#		print(texture)

# warning-ignore:unused_argument
#func _process(delta):
#	pass
	
