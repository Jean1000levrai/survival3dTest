extends StaticBody3D

var ore_health: float = 100.0
signal destroyed

@onready var ore1: CSGBox3D = $CSGBox3D/CSGBox3D4
@onready var ore2: CSGBox3D = $CSGBox3D/CSGBox3D
@onready var ore3: CSGBox3D = $CSGBox3D/CSGBox3D2
@onready var ore4: CSGBox3D = $CSGBox3D/CSGBox3D3

func health_state() -> void:
	var ores := [ore1, ore2, ore3, ore4]

	var health_ratio := ore_health / 100.0
	var ores_to_show := int(ceil(health_ratio * ores.size()))
	ores_to_show = clamp(ores_to_show, 0, ores.size())

	for i in range(ores.size()):
		ores[i].visible = i < ores_to_show


func destroy_ore() -> void:
	destroyed.emit()
	drop_ore_content()
	queue_free()
	
func drop_ore_content() -> void:
	pass

func mine_ore(damage: float) -> void:
	ore_health -= damage
	health_state()
	if ore_health <= 0:
		destroy_ore()
		
	
	
