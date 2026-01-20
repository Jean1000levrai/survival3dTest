extends Control


@onready var pause_panel: Panel = $PausePanel
@onready var game_over: Label = $GameOver

var is_paused = false


func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
	pause_panel.visible = is_paused
	Input.set_mouse_mode(
		Input.MOUSE_MODE_VISIBLE if is_paused else Input.MOUSE_MODE_CAPTURED
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func _on_button_button_up() -> void:
	toggle_pause()
