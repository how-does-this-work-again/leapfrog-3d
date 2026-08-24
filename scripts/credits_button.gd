extends ButtonAnimation

signal cred_btn_clicked
@onready var fade_tween: Tween

func _ready():
	connect("gui_input", _on_gui_input)
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	
	pivot_offset = size / 2.0 # sets pivot for animation to ensure it expands from center
	
	await get_tree().process_frame # wait until the node is part of the scene tree

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print('rygfwyrfiw')
		# kill previous tween if running to avoid overlap
		if fade_tween and fade_tween.is_running():
			fade_tween.kill()

		# create and configure the new scale animation
		fade_tween = create_tween()
		fade_tween.tween_property(self, "modulate:a", 0.0, 0.4)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN)

		cred_btn_clicked.emit()
