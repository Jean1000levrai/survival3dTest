extends CharacterBody3D


# V A R I A B L E S

# player statistics
@export var speed = 5.0
@export var sprint_multi = 2.0
@export var jump_velocity = 4.5

# stuff
var spawn_pos = Vector3(0, 2, 0)

# camera
@export var sensibilty = .3
@export var stick_sens := 3.0  # radians per second
@export var deadzone := 0.15
@export var min_pitch := deg_to_rad(-55)
@export var max_pitch := deg_to_rad(35)
@onready var camera_pivot = $cameraPivot


# M Y   F U N C T I O N S

func movement(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
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
		velocity.x = direction.x * speed * sprint_multi
		velocity.z = direction.z * speed * sprint_multi
	else:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	
	move_and_slide()
	
func try_destroy() -> void:
	var ray = $cameraPivot/Camera3D/InteractRay
	if Input.is_action_just_pressed("dig"):
		print("trying to dig")
		if ray.is_colliding():
			print("digging")
			var obj = ray.get_collider()
			if obj is RigidBody3D and obj.has_method("destroy"):
				obj.destroy()

func _on_game_over() -> void:
	global_position = spawn_pos

func controller_camera(delta: float) -> void:
	var look_x := Input.get_action_strength("look_right") - Input.get_action_strength("look_left")

	var look_y := Input.get_action_strength("look_down") - Input.get_action_strength("look_up")

	if abs(look_x) < deadzone:
		look_x = 0.0
	if abs(look_y) < deadzone:
		look_y = 0.0

	rotate_y(-look_x * stick_sens * delta)

	camera_pivot.rotate_x(-look_y * stick_sens * delta)
	camera_pivot.rotation.x = clamp(
		camera_pivot.rotation.x,
		min_pitch,
		max_pitch
	)



# G O D O T   F U N C T I O N S

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * sensibilty))
		camera_pivot.rotate_x(deg_to_rad(event.relative.y * -sensibilty))
		camera_pivot.rotation.x = clamp(
				camera_pivot.rotation.x,
				deg_to_rad(max_pitch),
				deg_to_rad(min_pitch),
			)
	
func _ready() -> void:
	print("hello world!")
	# signals reception
	var game_over_node = get_node("/root/Area3D2")
	game_over_node.respawn.connect(_on_game_over)

func _physics_process(delta: float) -> void:
	movement(delta)
	try_destroy()
	
func _process(delta: float) -> void:
	controller_camera(delta)