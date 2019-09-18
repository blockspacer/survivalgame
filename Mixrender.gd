extends ColorRect

export(NodePath) var cloudpath;
export(NodePath) var skypath;
onready var cloudtexture = get_node(cloudpath)
onready var skytexture = get_node(skypath)

# Called when the node enters the scene tree for the first time.
func _ready():
	print(skytexture , cloudtexture)
	if skytexture:
		material.set("shader_param/Sky",skytexture.get_viewport().get_texture())
		print(material.get("shader_param/Sky"))
	if cloudtexture:
		material.set("shader_param/Clouds",cloudtexture.get_viewport().get_texture())
		print(material.get("shader_param/Clouds"))

# warning-ignore:unused_argument
func _process(delta):
	pass
	
