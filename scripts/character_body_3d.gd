extends CharacterBody3D


# V A R I A B L E S

# signals
signal place_item_signal(hit_pos: Vector3)


# player statistics
@export var speed := 300.0
@export var sprint_multi := 2.0
@export var jump_velocity := 4.5
@export var damage := 20.0

# stuff
var spawn_pos = Vector3(0, 2, 0)
@onready var item: CSGBox3D = $Item
@onready var animation_player: AnimationPlayer = $player/AnimationPlayer
@export var coins := 0
@onready var coin_label: Label = $UI/CoinLabel

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
		animation_player.play("jump_idle")
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
		velocity.x = direction.x * speed * sprint_multi * delta
		velocity.z = direction.z * speed * sprint_multi * delta
	else:
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
	
	move_and_slide()

func dig() -> void:
	var ray = $cameraPivot/Camera3D/InteractRay
	if Input.is_action_just_pressed("dig"):
		print("trying to dig")
		if ray.is_colliding():
			print("digging")
			var obj = ray.get_collider()
			print(obj)
			print(obj.name)
			if obj is RigidBody3D and obj.has_method("destroy"):
				obj.destroy()
				item.visible = true
			if obj is StaticBody3D and obj.has_method("mine_ore"):
				obj.mine_ore(damage)
				add_coin(randi_range(2, 6))



func place_item() -> void:
	var ray = $cameraPivot/Camera3D/InteractRay
	if Input.is_action_just_pressed("place"):
		if item.visible and ray.is_colliding():
			var hit_pos = ray.get_collision_point()
			print(hit_pos)
			item.visible = false
			place_item_signal.emit(hit_pos)
		else:
			print("no item")
				

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

func animate() -> void:
	if is_on_floor():
		if velocity.length() > 0.4 and velocity.length() < 6:
			animation_player.play("walking")
		elif 0.4 < velocity.length() and velocity.length() > 6:
			animation_player.play("runing")
		elif velocity.length() < 0.1:
			animation_player.play("idle_01")
	


func add_coin(amount := 1):
	coins += amount
	update_coin_ui()
	
func update_coin_ui():
	coin_label.text = "Coins: %d" % coins

# G O D O T   F U N C T I O N S

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-deg_to_rad(event.relative.x * sensibilty))
		camera_pivot.rotate_x(deg_to_rad(event.relative.y * -sensibilty))
		camera_pivot.rotation.x = clamp(
				camera_pivot.rotation.x,
				min_pitch,
				max_pitch,
			)
	
func _ready() -> void:
	print("hello world!")
	update_coin_ui()

	
	# signals reception
	

func _physics_process(delta: float) -> void:
	# var rotation_offset = Vector3(0, deg_to_rad(180), 0)
	# rotation.y += rotation_offset.y
	movement(delta)
	animate()
	
	dig()
	place_item()
	
func _process(delta: float) -> void:
	controller_camera(delta)
