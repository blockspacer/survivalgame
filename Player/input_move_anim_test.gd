extends KinematicBody

export(int,0,60) var move_speed = 8 #units per second in 60 fps
export(float,0,1) var rotate_speed = .85 #how fast to lerp between rotation targets. Higher means longer transition.
export(float,0,5) var step_height = .5 #how high to step up vertically before moving horizontally. Changes what hill steepness a player can climb.
var move_vec = Vector3(0,0,0) #local location vector that is applied to the KinematicBody
var look_vec = Vector3(0,0,1) #local location vector that stores where the player should face between frames
var rot_vec = Vector3(0,0,0) #Euler rotation vector that stores the rotation to be applied to the player
var moving = false #if the player is moving this frame. for animation and such
var running = false #if the player is running this frame. for animation and such

var animControl #animation player reference
var walk_blend_target = 0 # this gets changed in code to be what position in the idle->walk blend the player is lerping towards
var walk_blend_speed = .2 # amount to lerp between current blend and the target blend

var walk_timescale_target = 0 # target of idle->walk timescale
var walk_timescale_speed = .2 # amount to lerp between current timescale and the target timescale

var activeCamera #for offsetting movement and rotation with
export(NodePath) var activeCameraPath

func _ready():
	print("Move using WASD")
	animControl = get_node("./Cubefriend/AnimationTree")
	animControl.active = true
	print(animControl)
	
	activeCamera = get_node(activeCameraPath)
	print(activeCamera)
	
	pass

#func _physics_process(delta):
	

#func _input(event):
	#pass

func _process(delta):
	
	## MOVEMENT
	
	#If a movement key is pressed, set the move_vec to indicate directions and report movement
	
	if Input.is_action_just_pressed("interact"):
		print("yeah")
	
	running = false
	
	if Input.is_action_pressed("move_run"): #run
		running = true
	
	moving = false
	
	if Input.is_action_pressed("move_up"): #up
		move_vec.z = Input.get_action_strength("move_up")
		moving = true
	elif Input.is_action_pressed("move_down"): #down
		move_vec.z = -Input.get_action_strength("move_down")
		moving = true
	else:
		move_vec.z = 0
	if Input.is_action_pressed("move_left"): #left
		move_vec.x = Input.get_action_strength("move_left")
		moving = true
	elif Input.is_action_pressed("move_right"): #right
		move_vec.x = -Input.get_action_strength("move_right")
		moving = true
	else:
		move_vec.x = 0
	
	#Normalize vector then adjust angle with camera rotation
	
	if ((move_vec.z==1 or move_vec.z==-1) and (move_vec.x==1 or move_vec.x==-1)):
		move_vec = move_vec.normalized()
	
	if (moving == true):
		look_vec = move_vec.rotated(Vector3.UP,activeCamera.rotation.y)
		move_vec = move_vec.rotated(Vector3.UP,activeCamera.rotation.y-PI)
	
	##ROTATION
	
	#Rotating the model according to calculated movement
	#If moving, calculate the target and current y axis rotation and slerp using a temp Quat conversion
	
	var to_quat = Quat() # declaring quat ...
	var from_quat = Quat()
	
	to_quat.set_euler(Vector3(0,atan2(look_vec.x, look_vec.z),0))

	from_quat.set_euler(rotation)
	to_quat = to_quat.normalized().slerp(from_quat.normalized(),rotate_speed)
	rot_vec = to_quat.get_euler()
	
	rotation = rot_vec
	
	if (moving == true):
		move_and_collide(Vector3 (0 , step_height , 0))
		if running==true:
			move_and_collide(move_vec * move_speed*2 * delta)
		elif running==false:
			move_and_collide(move_vec * move_speed * delta)
		move_and_collide(Vector3 (0 , -(step_height*2) , 0))
	
	## ANIMATION
	
	if (animControl != null):
		
		if moving:
			walk_blend_target = 1
		else:
			walk_blend_target = 0
		
		if running:
			walk_timescale_target = 2
		else:
			walk_timescale_target = 1
		
		animControl["parameters/walk_blend/blend_amount"] = lerp(animControl["parameters/walk_blend/blend_amount"],walk_blend_target,walk_blend_speed)
		
		animControl["parameters/walk_timescale/scale"] = lerp(animControl["parameters/walk_timescale/scale"],walk_timescale_target,walk_timescale_speed)
		
		if Input.is_action_pressed("interact"):
			animControl["parameters/interact_trigger/active"] = 1
		
	
	pass
