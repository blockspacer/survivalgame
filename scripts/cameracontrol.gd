extends Camera

#var defaultRotation = Vector3(-40,90,0)
#var defaultOffset = Vector3(0,20,0)
#var defaultDistance = 30

var Distance = 30
var Angle = Vector3(-20,0,0)
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

#onready var sky_b=get_tree().get_root().get_node("Spatial/Sky_texture")
onready var sky_b=get_tree().get_root().get_node("scene/Skybox")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var iChannel=sky_b.get_viewport().get_texture()
	self.environment=load("res://custom_environment.tres") as Environment
	self.environment.background_sky.set_panorama(iChannel)
	
	followPoint = get_node(followPointPath)
	print(followPoint)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	
	#Get camera buttons
	if Input.is_action_pressed("camera_rotate_left"): #rotate negative
		RotationSpeed = Input.get_action_strength("camera_rotate_left")
		if (Angle.y-RotationSpeed<-180):
			Angle.y = 180+(Angle.y-RotationSpeed+180)
		else:
			Angle.y = Angle.y - RotationSpeed
		#print(Angle.y)
	if Input.is_action_pressed("camera_rotate_right"): #rotate negative
		RotationSpeed = Input.get_action_strength("camera_rotate_right")
		if (Angle.y+RotationSpeed>180):
			Angle.y = -180+(Angle.y+RotationSpeed-180)
		else:
			Angle.y = Angle.y + RotationSpeed
		#print(Angle.y)
	
	if Input.is_action_pressed("camera_rotate_up"):
		Distance -= Input.get_action_strength("camera_rotate_up")/2
		Angle.x -= Input.get_action_strength("camera_rotate_up")
	if Input.is_action_pressed("camera_rotate_down"):
		Distance += Input.get_action_strength("camera_rotate_down")/2
		Angle.x += Input.get_action_strength("camera_rotate_down")
	
	Angle.x = clamp(Angle.x,-40,30)
	
	Distance = clamp(Distance, 8, 50) #distance starts at 30
	Offset.y = Distance*(2.0/3.0)+2 #offset starts at 22
	
	#print(Distance ," - ", Offset.y, " - ", Angle.x)
	
	if (followPoint!=null):
		moveCamera(Distance,Angle,followPoint.translation+Offset)
	
	pass
