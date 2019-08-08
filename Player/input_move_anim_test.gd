extends KinematicBody

export(int,0,60) var move_speed = 8 #pixels per second in 60 fps
export(float,0,1) var rotate_speed = .8 #how fast to lerp between rotation targets
export(float,0,5) var step_height = .5 #how high to step up before moving horizontally.
var move_vec = Vector3(0,0,0) #local location vector that is applied to the KinematicBody
var look_vec = Vector3(0,0,1) #local location vector that stores where the player should face between frames
var rot_vec = Vector3(0,0,0) #Euler rotation vector that stores the rotation to be applied to the player
var moving = false #if the player is moving this frame. for animation and such

var animControl #animation player reference

func _ready():
	print("Move using WASD")
	var animControl = get_node("./Cubefriend/AnimationTreePlayer")
	animControl.active = true
	print(animControl)
	pass

#func _physics_process(delta):
	

func _process(delta):
	
	## MOVEMENT
	
	#If a movement key is pressed, set the move_vec to indicate directions and report movement
	
	moving = false
	
	if (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_COMMA) or Input.is_key_pressed(KEY_UP)): #up
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
	
	#set the look_vec to lerp between last frame's look_vec point and the next point the player will move to
	#Bad Code
	
	#print(str(look_vec) + " " + str(translation) + " first")
	
	if (moving==true):
		look_vec = move_vec
	
	var to_quat = Quat() # declaring quat ...
	var from_quat = Quat()
	
	if (look_vec.z==0 and look_vec.x>0): # directly toward global +x axis
		to_quat.set_euler(Vector3(0,-(PI/2),0)) # ... then implementing does not raise construction errors
		from_quat.set_euler(rotation)
		to_quat = to_quat.slerp(from_quat,rotate_speed)
		rot_vec = to_quat.get_euler()
		print(rot_vec*(180/PI))
	elif (look_vec.z==0 and look_vec.x<0): # directly toward global -x axis
		to_quat.set_euler(Vector3(0,(PI/2),0)) # ... then implementing does not raise construction errors.
		from_quat.set_euler(rotation)
		to_quat = to_quat.slerp(from_quat,rotate_speed)
		rot_vec = to_quat.get_euler()
		print(rot_vec*(180/PI))
	elif (look_vec.x==0 and look_vec.z>0): # directly toward global +z axis
		to_quat.set_euler(Vector3(0,PI,0)) # ... then implementing does not raise construction errors.
		from_quat.set_euler(rotation)
		to_quat = to_quat.slerp(from_quat,rotate_speed)
		rot_vec = to_quat.get_euler()
		print(rot_vec*(180/PI))
	elif (look_vec.x==0 and look_vec.z<0): # directly toward global -z axis
		to_quat.set_euler(Vector3(0,0,0)) # ... then implementing does not raise construction errors.
		from_quat.set_euler(rotation)
		to_quat = to_quat.slerp(from_quat,rotate_speed)
		rot_vec = to_quat.get_euler()
		print(rot_vec*(180/PI))
	elif(look_vec.x!=0 and look_vec.z>0): # other angles < |90 degrees|
		var raw_angle = atan(look_vec.x/look_vec.z)
		if(raw_angle > 0):
			to_quat.set_euler(Vector3(0,-raw_angle-PI/2,0)) # ... then implementing does not raise construction errors.
		elif(raw_angle < 0):
			to_quat.set_euler(Vector3(0,-raw_angle+PI/2,0)) # ... then implementing does not raise construction errors.
		from_quat.set_euler(rotation)
		to_quat = to_quat.slerp(from_quat,rotate_speed)
		rot_vec = to_quat.get_euler()
		print(str(rot_vec*(180/PI)))
	elif(look_vec.x!=0 and look_vec.z<0): 
		to_quat.set_euler(Vector3(0,atan(look_vec.x/look_vec.z),0)) # ... then implementing does not raise construction errors.
		from_quat.set_euler(rotation)
		to_quat = to_quat.slerp(from_quat,rotate_speed)
		rot_vec = to_quat.get_euler()
		print(str(rot_vec*(180/PI)))
	else:
		print("look_vec is zero!?")
	
	rotation = rot_vec
	
	if (moving == true):
		move_and_collide(Vector3 (0 , step_height , 0))
		move_and_collide(move_vec * move_speed * delta)
		move_and_collide(Vector3 (0 , -(step_height*2) , 0))
	
	## ANIMATION
	
	#var animControl = get_node("Cubefriend/AnimationTreePlayer") #scope problem needs to be fixed so this doesn't need to be called every frame
	#print(animControl)
	
	if (animControl != null):
		
		if moving:
			animControl.blend2_node_set_amount("walk_blend",1)
		else:
			animControl.blend2_node_set_amount("walk_blend",0)
		
		if Input.is_key_pressed(KEY_E):
			animControl.oneshot_node_start("interact_moving_trigger")
		
		##print(animControl,animControl.active,animControl.blend2_node_get_amount("walk_blend"))
		
	
	pass



