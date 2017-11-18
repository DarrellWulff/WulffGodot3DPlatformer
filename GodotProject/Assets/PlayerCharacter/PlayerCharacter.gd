extends RigidBody
#Godot RigidBody Based Movement
# By Darrell Wulff
# class member variables:
#var moveSpeed
#var MoveVelocity
#var JumpVelocity
#var JumpHeight

#Exports
export(float) var moveSpeed
export(float) var JumpHeight
export(float) var MouseSensitivity
var Grounded
var ground
export(NodePath) var parent_path
export(NodePath) var self_path

#RayCast Node Attached to the PlayerBase
var groundCheckRayCast = [5]
#Camera Node Attached to the PlayerBase


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	Grounded = true
	
	set_fixed_process(true)
	
	set_mode(2)
	
	set_contact_monitor(true)
	
	set_max_contacts_reported(true)
	
	groundCheckRayCast[0] = get_node("RayCast")
	groundCheckRayCast[1] = get_node("RayCast1")
	groundCheckRayCast[2] = get_node("RayCast2")
	groundCheckRayCast[3] = get_node("RayCast3")
	groundCheckRayCast[4] = get_node("RayCast4")
	
	for i in Range(0, 5):
		groundCheckRayCast[i].add_exception(get_owner())
	
	
	ground = get_node(parent_path)
	
	
	pass
	
func on_ground_check():
	for i in Range(0, 5):
		if(groundCheckRayCast[i].is_colliding()):
			return true
	
func _fixed_process(delta):
	#Update with physics.
	
	
	
	#INPUT Logic
	if(Input.is_action_pressed("Move_Right")):
		set_linear_velocity(Vector3(1 * moveSpeed,0,0))
	
	if(Input.is_action_pressed("Move_Left")):
		set_linear_velocity(Vector3(-1 * moveSpeed,0,0))
	
	if(Input.is_action_pressed("Move_Up")):
		set_linear_velocity(Vector3(0,0,-1 * moveSpeed))
	
	if(Input.is_action_pressed("Move_Down")):
		set_linear_velocity(Vector3(0,0,1 * moveSpeed))
		
		
	if(on_ground_check() == true):
		if(Input.is_action_pressed("Jump")):
			set_linear_velocity(Vector3(0,1 * JumpHeight,0))
	
	
	