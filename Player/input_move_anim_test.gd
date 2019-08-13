extends KinematicBody

export(int,0,60) var move_speed = 8 #units per second in 60 fps
export(float,0,1) var rotate_speed = .85 #how fast to lerp between rotation targets. Higher means longer transition.
export(float,0,5) var step_height = .5 #how high to step up vertically before moving horizontally. Changes what hill steepness a player can climb.
var move_vec = Vector3(0,0,0) #local location vector that is applied to the KinematicBody
var look_vec = Vector3(0,0,1) #local location vector that stores where the player should face between frames
var rot_vec = Vector3(0,0,0) #Euler rotation vector that stores the rotation to be applied to the player
var moving = false #if the player is moving this frame. for animation and such

var animControl #animation player reference
var walk_blend_target = 0
var walk_blend_speed = .2

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
	

func _process(delta):
	
	## MOVEMENT
	
	#If a movement key is pressed, set the move_vec to indicate directions and report movement
	
	moving = false
	
	if (Input.is_key_pressed(KEY_W) or (Input.is_key_pressed(KEY_COMMA) or Input.is_key_pressed(KEY_LESS)) or Input.is_key_pressed(KEY_UP)): #up
		move_vec.z = 1
		moving = true
	elif (Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_O) or Input.is_key_pressed(KEY_DOWN)): #down
		move_vec.z = -1
		moving = true
	else:
		move_vec.z = 0
	if (Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)): #left
		move_vec.x = 1
		moving = true
	elif (Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_E) or Input.is_key_pressed(KEY_RIGHT)): #right
		move_vec.x = -1
		moving = true
	else:
		move_vec.x = 0
	
	#Normalize vector then adjust angle with camera rotation
	
	if (moving == true):
		move_vec = move_vec.normalized()
		look_vec = move_vec.rotated(Vector3.UP,activeCamera.rotation.y)
		move_vec = move_vec.rotated(Vector3.UP,activeCamera.rotation.y-PI)
	
	##ROTATION
	
	#Rotating the model according to calculated movement
	#If moving, calculate the target and current y axis rotation and slerp using a temp Quat conversion
	
	var to_quat = Quat() # declaring quat ...
	var from_quat = Quat()
	
	to_quat.set_euler(Vector3(0,atan2(look_vec.x, look_vec.z),0))

	from_quat.set_euler(rotation)
	to_quat = to_quat.normalized().slerp(from_quat.normalized(),rotate_speed*delta)
	rot_vec = to_quat.get_euler()
	
	rotation = rot_vec
	
	if (moving == true):
		move_and_collide(Vector3 (0 , step_height , 0))
		move_and_collide(move_vec * move_speed * delta)
		move_and_collide(Vector3 (0 , -(step_height*2) , 0))
	
	## ANIMATION
	
	if (animControl != null):
		
		if moving:
			walk_blend_target = 1
		else:
			walk_blend_target = 0
		
		animControl["parameters/walk_blend/blend_amount"] = lerp(animControl["parameters/walk_blend/blend_amount"],walk_blend_target,walk_blend_speed)
		
		if Input.is_key_pressed(KEY_E):
			animControl["parameters/interact_trigger/active"] = 1
		
	
	pass
