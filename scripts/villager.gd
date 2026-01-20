extends RigidBody3D

@export var villager_speed = 0.5
enum {IDLE, DEAD}
var state := IDLE

var target: Vector3
var reach_distance := 0.5
var idle_radius := 10.0

func villager_death() -> void:
	queue_free()

func pick_new_target():
	target = global_position + Vector3(
		randf_range(-idle_radius, idle_radius),
		0,
		randf_range(-idle_radius, idle_radius)
	)

func villager_move_idling() -> void:
	if state != IDLE:
		return

	var to_target = target - global_position
	to_target.y = 0

	if to_target.length() < reach_distance:
		pick_new_target()
		return

	var direction = to_target.normalized()
	linear_velocity.x = direction.x * villager_speed
	linear_velocity.z = direction.z * villager_speed
	rotation.y = atan2(to_target.x, to_target.z)
	
func _ready():
	randomize()
	pick_new_target()

func _physics_process(_delta: float) -> void:
	villager_move_idling()
