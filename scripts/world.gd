extends Node3D

var player_instance: Node
var is_paused = false
@onready var pause_label: Label = $ui/Pause

func _ready() -> void:
	var enemy_scene = preload("res://scenes/player.tscn")
	player_instance = enemy_scene.instantiate()
	add_child(player_instance)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

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
	
	




	
