# i forget why i made this file ngl so now it doesnt do anything
extends TextureRect

# Define target focus point and scaling settings
@export var focus_point := Vector2(600, 572) # Pixel coordinates of target area
@export var zoom_scale := Vector2(1/(2.25), 1/(4.9))   # Non-uniform scale adds a stretching effect
@export var transition_duration := 1.2        # Duration in seconds

var active_tween: Tween

@onready var back_button = %BackButton

func _ready() -> void:
	GlobalEvents.back_btn_clicked.connect(_on_back_btn_clicked)

func _on_back_btn_clicked() -> void:
	pass
