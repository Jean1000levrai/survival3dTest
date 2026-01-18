extends Node3D

var player_instance: Node
var is_paused = false
@onready var pause_label: Label = $ui/Pause
@onready var player = preload("res://scenes/player.tscn")

func _ready() -> void:
	player_instance = player.instantiate()
	add_child(player_instance)
	player_instance.place_item_signal.connect(_on_place_item_signal)

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_place_item_signal(hit_pos: Vector3) -> void:
	hit_pos.y += 0.5
	var crate = preload("res://scenes/crate.tscn").instantiate()
	crate.global_position = hit_pos
	add_child(crate)

func trigger_pause(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		is_paused = true
		pause_label.visible = true
	elif event.is_action_pressed("pause") and is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		is_paused = false
		pause_label.visible = false

func _input(event: InputEvent) -> void:
	trigger_pause(event)
	
	




	
