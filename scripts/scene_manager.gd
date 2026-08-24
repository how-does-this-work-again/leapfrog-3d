extends Node

func crossfade_to_scene(target_scene_path: String, duration: float = 1.0, delete_old_scene: bool = true) -> void:
	var current_scene = get_tree().current_scene
	
	# Load the new scene
	var new_scene_resource = load(target_scene_path)
	var new_scene = new_scene_resource.instantiate()
	
	# Start the new scene invisible and add it to the root
	if new_scene is CanvasItem or new_scene is Node2D or new_scene is Control:
		new_scene.modulate.a = 0.0
	
	get_tree().root.add_child(new_scene)
	
	# Create parallel tween to fade the old scene out while fading the new scene in
	var tween = create_tween().set_parallel(true)
	
	# Fade out current scene
	tween.tween_property(current_scene, "modulate:a", 0.0, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	# you cant fade into 3d scene soooo yeah
	if target_scene_path != "res://scenes/test_scene.tscn":
		# Fade in new scene
		tween.tween_property(new_scene, "modulate:a", 1.0, duration)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN_OUT)
	
	# Wait for animation to finish
	await tween.finished
	
	# Set new scene as current and clean up the old scene
	get_tree().current_scene = new_scene
	
	# Conditionally delete or keep/hide the old scene
	if delete_old_scene:
		current_scene.queue_free()
	else:
		current_scene.hide() # Hides visuals and stops input processing
