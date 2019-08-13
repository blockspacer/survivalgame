extends Camera

var defaultRotation = Vector3(-40,90,0)
#var defaultOffset = Vector3(0,20,0)
var defaultDistance = 30

var Distance = 30
var Angle = Vector3(-40,0,0)
var Offset = Vector3(0,20,0)

var RotationSpeed = 1

export(NodePath) var followPointPath
var followPoint

func moveCamera(length,angle,offset):
	#length (float) = distance to step away from offset
	#rotation (Vector3) = rotation of camera. Y is most important
	#offset (Vector3) = origin of camera calcs and world position
	self.translation = Vector3(offset.x+(length*cos(deg2rad(angle.y))),offset.y,offset.z+(length*sin(deg2rad(angle.y))))
	self.rotation_degrees = Vector3(angle.x,-angle.y+90,angle.z)
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	
	followPoint = get_node(followPointPath)
	print(followPoint)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Get camera buttons
	if (Input.is_key_pressed(KEY_APOSTROPHE) && !(Input.is_key_pressed(KEY_PERIOD))): #rotate negative
		if (Angle.y-RotationSpeed<-180):
			Angle.y = 180+(Angle.y-RotationSpeed+180)
		else:
			Angle.y = Angle.y - RotationSpeed
		print(Angle.y)
	if (Input.is_key_pressed(KEY_PERIOD) && !(Input.is_key_pressed(KEY_APOSTROPHE))): #rotate negative
		if (Angle.y+RotationSpeed>180):
			Angle.y = -180+(Angle.y+RotationSpeed-180)
		else:
			Angle.y = Angle.y + RotationSpeed
		print(Angle.y)
	
	if (followPoint!=null):
		moveCamera(Distance,Angle,followPoint.translation+Offset)
	
	pass
