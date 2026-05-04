extends CharacterBody3D

@export var ANIM_PLAYER : AnimationPlayer

@export_range(5, 10, 0.1) var CROUCH_SPEED : float = 7.0

@export var SPEED : float = 5.5
@export var SPEED_CROUCH : float = 2.25
@export var SPEED_WALK : float = 3.15
@export var JUMP_VELOCITY : float = 4.5
@export var MSENS : float = 0.03

var _speed : float

#bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.8

var gravity = 9.8

var _is_crouching : bool = false

var _is_walking : bool = false

@onready var head = $Head
@onready var camera = $Head/Eyes

func _ready():
	_speed = SPEED
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * MSENS)
		camera.rotate_x(-event.relative.y * MSENS)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	
	if _global.debug != null:
		_global.debug.add_property("MovementSpeed", _speed, 1)
		_global.debug.add_property("MouseSensivity", MSENS, 2)
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("Chicken"):	#Another Chicken
		toggle_crouch()
	elif Input.is_action_just_pressed("Sprint"):
		toggle_walk()
	
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction : Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * _speed
		velocity.z = direction.z * _speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	#Movin' a head while Walkin' or Runnin'
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	move_and_slide()
	
func _headbob(time) -> Vector3:
	var pos =Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func toggle_crouch():	# Chicken Mode
	if _is_crouching:
		ANIM_PLAYER.play("crouch", -1, CROUCH_SPEED * -1, true)
		_speed = SPEED
		print("UNCHICKEN")	# Yep another chicken classic
	elif !_is_crouching:
		ANIM_PLAYER.play("crouch", -1, CROUCH_SPEED)
		_speed = SPEED_CROUCH
		print("CHICKEN")	# Yep another chicken classic
	_is_crouching = !_is_crouching
func toggle_walk():
	if _is_walking:
		_speed = SPEED
	elif !_is_walking:
		_speed = SPEED_WALK
	_is_walking = !_is_walking
