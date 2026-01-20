extends Area3D

@onready var UI: Control = $"../UI"
signal game_over


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	print("ok")

func _on_body_entered(body: Node3D) -> void:
	print(body.name)
	if body.name == "CharacterBody":
		game_over.emit()
		
