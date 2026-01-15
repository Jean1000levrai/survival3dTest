extends CharacterBody3D


@export var SPEED = 5.0
@export var SPRINT_MULTI = 2.0
@export var JUMP_VELOCITY = 4.5
@export var sens = .5

func _ready() -> void:
	print("hello world!")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * sens))


func movement(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("move_backward"):
		input_dir.z = 1
	if Input.is_action_pressed("move_forward"):
		input_dir.z = -1
	if Input.is_action_pressed("move_left"):
		input_dir.x = -1
	if Input.is_action_pressed("move_right"):
		input_dir.x = 1

	input_dir = input_dir.normalized()

	var direction = transform.basis * input_dir
	if Input.is_action_pressed("sprint"):
		velocity.x = direction.x * SPEED * SPRINT_MULTI
		velocity.z = direction.z * SPEED * SPRINT_MULTI
	else:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	
	move_and_slide()
	

func _physics_process(delta: float) -> void:
	movement(delta)
	
