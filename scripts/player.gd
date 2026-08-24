extends CharacterBody3D

# we r js full resetting and making 3d flappy bird
# the idea is the frog is constantly moving and will hit obstacles
# such as trees and predators
# so it has to jump over those
# and then to turn 

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

@export var jump_force: float = 30.0
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var rotation_speed: float = 2.0  # how fast the frog rotates
@export var MAX_ZOOM = 50.0

# nodes
@onready var frog_normal: Node3D = $Pivot/frog_normal
@onready var frog_jump: Node3D = $Pivot/frog_jump
@onready var pivot = $Pivot
@onready var spring_arm: SpringArm3D = $SpringArm3D 
@onready var jump_timer: Timer = $Pivot/JumpTimer

var facedir = true
var target_velocity = Vector3.ZERO

# Sensitivity of the camera, in degrees. Larger number = more camera movement with mouse.
@export_range(0.01, 1, 0.01) var VIEW_SENSITIVITY = 0.01
# Convert the VIEW_SENSITIVITY to radians, because it is easier to input degrees when testing.
@onready var sensitivity = deg_to_rad(VIEW_SENSITIVITY)
@export var tilt_limit = deg_to_rad(75)

var restore_mouse_pos = Vector2()

# This constant helps us constrain the camera pitch to just below 90 degrees in both directions.
const MAX_PITCH = (PI / 2) - deg_to_rad(1)

func _ready():
	# Hide the jump frog initially
	frog_jump.visible = false

func _unhandled_input(ev: InputEvent) -> void:
	#if Input.is_action_pressed("camera_zoom_in"):
		#spring_arm.set_length(clamp(spring_arm.spring_length + 1, 0, MAX_ZOOM))
	#elif Input.is_action_pressed("camera_zoom_out"):
		#spring_arm.set_length(clamp(spring_arm.spring_length - 1, 0, MAX_ZOOM))

	if ev is InputEventMouseMotion:
		pass

# switch back to the normal frog after the timer runs out
func _on_jump_timer_timeout():
	frog_normal.visible = true
	frog_jump.visible = false

func _physics_process(delta):
	var direction = Vector3.ZERO
	direction += Vector3.FORWARD * 2 # constantly moving forward
	
	if Input.is_action_just_pressed("rotate_left"):
		#rotate_y(rotation_speed * delta) # the directions should in theory be reversed but if it works it works
		rotate_y(PI/2)
		facedir = true
	if Input.is_action_just_pressed("rotate_right"):
		rotate_y(-PI/2)
		#rotate_y(-1 * rotation_speed * delta)
		facedir = true
	
	#if Input.is_action_pressed("move_forward"):
		#direction += Vector3.FORWARD
		#facedir = true
	#if Input.is_action_pressed("move_back"):
		#direction += Vector3.BACK
		#facedir = false
	if Input.is_action_pressed("move_right"):
		direction += Vector3.RIGHT
		facedir = false
	if Input.is_action_pressed("move_left"):
		direction += Vector3.LEFT
		facedir = false
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		direction = global_transform.basis * direction
		# Setting the basis property will affect the rotation of the node.
		if facedir == true:
			$Pivot.look_at(global_transform.origin + direction, Vector3.UP)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	
	# Jumping.
	#if is_on_floor() and Input.is_action_just_pressed("jump"):
	if Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_force
		frog_normal.visible = false
		frog_jump.visible = true
		jump_timer.start()
	


	# Moving the Character
	velocity = target_velocity
	move_and_slide()
