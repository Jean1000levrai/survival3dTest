extends Area3D

@onready var game_over: Label = $"../ui/GameOver"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	print("ok")

func _on_body_entered(body: Node3D) -> void:
	print("good")
	print(body.name)
	if body.name == "CharacterBody":
		print("u died lol")
		game_over.visible = true
		
