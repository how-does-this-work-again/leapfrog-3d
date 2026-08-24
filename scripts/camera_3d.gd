extends Camera3D

func _process(_delta):
	var mouse_input = 0.0
	
	if(Input.is_action_pressed("camera_zoom_in")):
		mouse_input += 1.0
	if(Input.is_action_pressed("camera_zoom_out")):
		mouse_input -= 1.0
	
	fov -= mouse_input
