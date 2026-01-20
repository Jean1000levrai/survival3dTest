extends Node3D

var player_instance: Node
var player_spawn_pos: Vector3 = Vector3(0, 2, 0)
var villager_spawn_pos: Vector3

@onready var pause_label: Label = $ui/Pause
@onready var player = preload("res://scenes/player.tscn")
@onready var villager = preload("res://scenes/villager.tscn")
const BasicOre = preload("uid://cfmoj5enriiy8")


func spawn_villager() -> void:
	villager_spawn_pos = Vector3(randi_range(-10, 10), 2, randi_range(-10, 10))
	var villager_instance = villager.instantiate()
	add_child(villager_instance)
	villager_instance.transform.origin = villager_spawn_pos

func spawn_player() -> void:
	if player_instance != null:
		player_instance.queue_free()
	player_instance = player.instantiate()
	add_child(player_instance)
	player_instance.transform.origin = player_spawn_pos
	player_instance.place_item_signal.connect(_on_place_item_signal)



func _ready() -> void:
	spawn_player()
	for i in range(10):
		spawn_villager()

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_place_item_signal(hit_pos: Vector3) -> void:
	hit_pos.y += 0.5
	var crate = preload("res://scenes/crate.tscn").instantiate()
	crate.global_position = hit_pos
	add_child(crate)






	
