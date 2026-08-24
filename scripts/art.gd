extends TextureRect

# Define target focus point and scaling settings
@export var focus_point := Vector2(601, 570) # Pixel coordinates of target area
@export var zoom_in_scale := Vector2(2.23, 4.95) # Non-uniform scale adds a stretching effect
@export var zoom_out_scale := Vector2(1, 1)
@export var transition_duration := 1.2 # Duration in seconds

var active_tween: Tween

@onready var start_button = %StartButton
@onready var cred_button = %CreditsButton

func _ready() -> void:
	if GlobalEvents.main_art_start_zoomed_in:
		await get_tree().process_frame
		pivot_offset = focus_point
		scale = zoom_in_scale
		
		start_button.modulate.a = 0
		cred_button.modulate.a = 0
		print('fwrf')
		zoom_out_n_stuff()

	if cred_button:
		cred_button.cred_btn_clicked.connect(_on_cred_btn_clicked)
	
	GlobalEvents.back_btn_clicked.connect(_on_back_btn_clicked)
	
func _on_cred_btn_clicked() -> void:
	# 1. Set the transformation pivot to the focus location
	pivot_offset = focus_point
	
	# 2. Kill existing tween if active
	if active_tween and active_tween.is_running():
		active_tween.kill()
	
	active_tween = create_tween().set_parallel(true)

	# 3. Animate Zoom and Stretch
	# TRANS_CUBIC / TRANS_QUINT with EASE_IN creates a accelerating "rush-in" effect
	active_tween.tween_property(self, "scale", zoom_in_scale, transition_duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
	
	# 5. Wait for tween completion before changing scenes
	await active_tween.finished
	SceneManager.crossfade_to_scene("res://scenes/credits.tscn", 0.7, false)

func zoom_out_n_stuff():
	# 2. Kill existing tween if active
	if active_tween and active_tween.is_running():
		active_tween.kill()
	
	active_tween = create_tween().set_parallel()
	
	active_tween.tween_property(self, "scale", Vector2(1, 1), 1.0)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
	active_tween.tween_property(start_button, "modulate:a", 1.0, 1.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)\
		.set_delay(0.8)
	active_tween.tween_property(cred_button, "modulate:a", 1.0, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)\
		.set_delay(0.8)
	
	# 5. Wait for tween completion before changing scenes
	await active_tween.finished

func _on_back_btn_clicked():
	GlobalEvents.main_art_start_zoomed_in = true # now need to figure out how to reset it to false
