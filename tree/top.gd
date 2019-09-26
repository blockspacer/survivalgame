extends MeshInstance

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.mesh.set("blend_shapes/Displace_1", rand_range(-2.0,2.0))
	self.mesh.set("blend_shapes/Displace_2", rand_range(-2.0,2.0))
	prints("tree top", self.mesh.get("blend_shapes/Displace1"))
	
	prints("tree top", get_property_list())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
