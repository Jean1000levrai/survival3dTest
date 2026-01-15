extends Area3D

# var PLAYER = $"../player"

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	print("ok")

func _on_body_entered(body: Node3D) -> void:
	print("good")
	if body.name == "player":
		print("u died lol")
		$"../Label".visible = true
		
