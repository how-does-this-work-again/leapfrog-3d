extends ButtonAnimation

var fade_tween: Tween
@onready var cred_button = %CreditsButton

func _ready():
	connect("gui_input", _on_gui_input)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	
	if cred_button:
		cred_button.cred_btn_clicked.connect(_on_cred_btn_clicked)
	
	pivot_offset = size / 2.0 # sets pivot for animation to ensure it expands from center
	
	await get_tree().process_frame # wait until the node is part of the scene tree

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		SceneManager.crossfade_to_scene("res://scenes/test_scene.tscn") # move to main scene
		# TODO change to real main scene (not testing) when done

func _on_cred_btn_clicked():
	# kill previous tween if running to avoid overlap
	if fade_tween and fade_tween.is_running():
		fade_tween.kill()

	# create and configure the new scale animation
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)

func black_fade_to_scene(scene_path: String):
	# Fade to black
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1.0, 0.5)  # Fade to black
	await tween.finished

	# Change the scene
	get_tree().change_scene_to_file(scene_path)

	# Fade back in (optional)
	tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 0.0, 0.5)  # Fade back in
