extends CharacterBody3D


const MAX_SPEED = 3.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.001
const ACCELERATION= 7

const BOB_FREQ = 4.0
const BOB_AMP = 0.05
var t_bob = 0.0

var CURRENT_SPEED = 0

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var weaponhandler = $Head/Camera3D/WeaponHandler

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var direction = (head.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if CURRENT_SPEED <= MAX_SPEED:
		CURRENT_SPEED +=ACCELERATION * delta
	
	if direction.x == 0:
			CURRENT_SPEED = 0
			velocity.x = 0
	
	if direction.z == 0:
			CURRENT_SPEED = 0
			velocity.z = 0
	

		
	if direction:
		velocity.x = direction.x * CURRENT_SPEED
		velocity.z = direction.z * CURRENT_SPEED
		weaponhandler.update_sway(true)
		
	else:
		velocity.x = move_toward(velocity.x, 0, CURRENT_SPEED)
		velocity.z = move_toward(velocity.z, 0, CURRENT_SPEED)
		weaponhandler.update_sway(false)
		
	t_bob += delta * velocity.length() * float(is_on_floor())
	head.transform.origin = _headbob(t_bob)
		
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	return pos
