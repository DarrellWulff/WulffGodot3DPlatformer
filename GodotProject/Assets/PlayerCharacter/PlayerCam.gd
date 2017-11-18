extends Camera

# class member variables go here, for example:
var gameHasStarted
export(float) var MouseSensitivity
var mouseCamView

func _ready():
	gameHasStarted = true
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass
func _process(delta):
	if(gameHasStarted):
		mouseCamView = project_ray_normal(get_viewport().get_mouse_pos())
		#look_at_from_pos(get_translation(), mouseCamView*MouseSensitivity,Vector3(0,1,0))
		#get_viewport().get_mouse_pos()