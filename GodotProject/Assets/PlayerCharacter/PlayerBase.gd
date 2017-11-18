extends Node 


# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(float) var moveSpeed
export(float) var JumpHeight
var currentJumpVelocity
export(float) var MouseSensitivity

var Grounded
var ground

export(NodePath) var parent_path
export(NodePath) var rigidbody_path
export(NodePath) var timer_path

#Array of Raycast's Node Paths
export(NodePath) var ray_path
export(NodePath) var ray_path1
export(NodePath) var ray_path2
export(NodePath) var ray_path3
export(NodePath) var ray_path4

var characterBody
export(bool) var isCollided

var jumpDirectionX
var jumpDirectionZ

var curJumpDirX = 0
var curJumpDirZ = 0

var playerInputTimer
var buttonPressTime

#RayCast Node Attached to the PlayerBase
var groundCheckRayCast = [0,0,0,0,0]

#Camera Code from Calinou FPS - Test
var view_sensitivity = 0.25
var yaw = 0
var pitch = 0
var is_moving = false







func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	#Use this for ground movement and animations
	Grounded = true
	
	#Get path to rigidbody set in the inspector
	characterBody = get_node(rigidbody_path)
	#Get path to our timer node for input time
	
	#path to the raycast nodes
	groundCheckRayCast[0] = get_node(ray_path)
	groundCheckRayCast[1] = get_node(ray_path1)
	groundCheckRayCast[2] = get_node(ray_path2)
	groundCheckRayCast[3] = get_node(ray_path3)
	groundCheckRayCast[4] = get_node(ray_path4)
	
	
	#Add an exception to the raycast colliding, so it does not detect the player
	for i in range(4):
		groundCheckRayCast[i].add_exception(characterBody)
	
	#make our physics update
	set_fixed_process(true)
	
	
	#make our character not rotate
	characterBody.set_mode(2)
	
	#Player Camera Code
	# Capture mouse once game is started:
	set_process_input(true)
	
	
	pass

func _input(event):
	if event.type == InputEvent.MOUSE_MOTION:
		yaw = fmod(yaw - event.relative_x * view_sensitivity, 360)
		pitch = max(min(pitch - event.relative_y * view_sensitivity, 85), -85)
		
		
		get_node("Player/Camera").set_rotation(Vector3(deg2rad(pitch), deg2rad(yaw), 0))
	
	#Check if our raycast is colliding with anything
func on_ground_check():
	for i in range(4):
		if(groundCheckRayCast[i].is_colliding() == true):
			return true
		
		
		
func jumpInfluenceX(delta):
	if(Input.is_action_pressed("Move_Right")):
		
		buttonPressTime = 0
		
		"""if(Input.action_release("Move_Right") && buttonPressTime < .2):
			jumpDirectionX = moveSpeed - 5
			return jumpDirectionX"""
		
		#jumpDirectionX = moveSpeed
		jumpDirectionX = lerp(moveSpeed - 3, moveSpeed + 35, 5 * delta)
		#jumpDirectionX = characterBody.set_linear_velocity(characterBody.get_global_transform().basis.x.normalized() * moveSpeed)
		return jumpDirectionX
	
	if(Input.is_action_pressed("Move_Left")):
		#jumpDirectionX = -lerp(moveSpeed - 3, moveSpeed + 35, 5 * delta)
		jumpDirectionX = characterBody.transform().x * -moveSpeed
		return jumpDirectionX
		
	return 0
		
func jumpInfluenceZ(delta):
	if(Input.is_action_pressed("Move_Up")):
		jumpDirectionZ = -lerp(moveSpeed - 3, moveSpeed + 35, 5 * delta)
		#jumpDirectionZ = characterBody.set_linear_velocity(characterBody.get_global_transform().basis.z.normalized() * -moveSpeed)
		return jumpDirectionZ
	
	if(Input.is_action_pressed("Move_Down")):
		jumpDirectionZ = lerp(moveSpeed - 3, moveSpeed + 35, 5 * delta)
		#jumpDirectionZ = characterBody.set_linear_velocity(characterBody.get_global_transform().basis.z.normalized() * moveSpeed)
		return jumpDirectionZ
	
	return 0
		
func jumpSelfRef():
	currentJumpVelocity = characterBody.get_linear_velocity().y
	return currentJumpVelocity
	
		
func _fixed_process(delta):
	#Update with physics.
	#get_node("Player/Yaw").set_rotation(Vector3(0, deg2rad(yaw), 0))
	get_node("Player").set_rotation(Vector3(0, deg2rad(yaw), 0))
	
	#characterBody.rotate_y(deg2rad(yaw))
	
		#INPUT Logic for being on the ground
	if(Input.is_action_pressed("Move_Right")  && on_ground_check()):
		#characterBody.set_linear_velocity(Vector3(1 * moveSpeed,0,0))
		characterBody.set_linear_velocity(characterBody.get_global_transform().basis.x.normalized() * moveSpeed)
	
	if(Input.is_action_pressed("Move_Left") && on_ground_check()):
		#characterBody.set_linear_velocity(Vector3(-1 * moveSpeed,0,0))
		characterBody.set_linear_velocity(characterBody.get_global_transform().basis.x.normalized() * -moveSpeed)
	
	if(Input.is_action_pressed("Move_Up") && on_ground_check()):
		#characterBody.set_linear_velocity(Vector3(0,0,-1 * moveSpeed ))
		characterBody.set_linear_velocity(characterBody.get_global_transform().basis.z.normalized() * -moveSpeed)
		#characterBody.apply_impulse(Vector3(0,0,0), characterBody.get_global_transform().basis.z.normalized() * delta * moveSpeed)
	
	if(Input.is_action_pressed("Move_Down") && on_ground_check()):
		#characterBody.set_linear_velocity(Vector3(0,0,1 * moveSpeed))
		characterBody.set_linear_velocity(characterBody.get_global_transform().basis.z.normalized() * moveSpeed)
	
	if(on_ground_check()):
		Grounded = true
	
		
	if(Input.is_action_pressed("Jump") && on_ground_check()):
		characterBody.set_linear_velocity(Vector3(0, 1 * JumpHeight, 0))
		
		Grounded = false
		
	if(Grounded == false):
		characterBody.set_linear_velocity(Vector3(0, jumpSelfRef(), 0))
		#characterBody.set_axis_velocity(Vector3(0,JumpHeight,0))
		
		

