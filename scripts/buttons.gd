class_name ButtonAnimation
extends TextureRect

@export var hover_scale = 1.1
@onready var tween: Tween
#TODO: figure out tweening for animation done?
#TODO: add credits button [add functionality]
#TODO: expand size slightly when hovered DONE

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	
	pivot_offset = size / 2.0 # sets pivot for animation to ensure it expands from center
	
	await get_tree().process_frame # wait until the node is part of the scene tree

func _on_mouse_entered():
	_animate_scale(hover_scale)

func _on_mouse_exited():
	_animate_scale(1.0)

func _animate_scale(target_scale: float) -> void:
	# kill previous tween if running to avoid overlap
	if tween and tween.is_running():
		tween.kill()

	# create and configure the new scale animation
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(target_scale, target_scale), 0.15)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
