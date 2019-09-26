extends MeshInstance

export(int,1,12) var width = 2 # 2/8 x
export(float) var length = 4 # 4 y
export(int,1,12) var height = 4 # 4/8 z

onready var self_seed = randi()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.mesh.set_size(Vector3(width*0.125,length,height*0.125))
#	prints("plank", self.mesh.get_size())
	self.mesh.subdivide_width = floor((width*0.125)*2-1) # x
	self.mesh.subdivide_height = floor((length)*2-1) # y
	self.mesh.subdivide_depth = floor((height*0.125)*2-1) # z
#	prints("plank", self.mesh.subdivide_width, self.mesh.subdivide_height, self.mesh.subdivide_depth)
	prints("plank", self, self_seed)

# warning-ignore:unused_argument
func _process(delta):
	pass
